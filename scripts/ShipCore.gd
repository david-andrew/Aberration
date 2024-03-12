extends RigidBody3D
class_name ShipCore

@export var player_controlled: bool = false
#var teamid: TeamID
var enemies: Array[RigidBody3D] = []
var allies: Array[RigidBody3D] = []
var thrusters: ThrustModule

var target: RigidBody3D = null #current forward target
const TIME_TO_REEVALUATE_TARGET_MS = 1000 #if the target remains valid the whole time
var target_selection_time = Time.get_ticks_msec() + int(randf() * TIME_TO_REEVALUATE_TARGET_MS)



func _ready():
	# ensure that the teamID is the first node
	var teamID:TeamID = find_child("TeamID")
	move_child(teamID, 0)
	
	# mark targets for all turrets
	enemies = teamID.get_all_enemy_units()
	allies = teamID.get_all_allied_units()
	for child in get_children():
		if is_instance_valid(child) and child is CannonModule:
			child.set_targets(enemies)
			
	thrusters = $ThrustModule



func _physics_process(delta):
	select_forward_target()
	if not is_instance_valid(target):
		return
	
	if not is_instance_valid(thrusters):
		return
	
	avoid_other_ships()
	
	#thrusters.translate_towards(target.global_position)
	thrusters.point_towards(target.global_position, delta)
	thrusters.thrust_forward(1.0)
	#apply_central_force(basis * Vector3.FORWARD * 1000)
	pass
	
	#var local_angular = angular_velocity * global_basis
	##local_angular.x = 1
	#local_angular.z = 0#sign(local_angular.z) * min(abs(local_angular.z), 0.1)
	#angular_velocity = global_basis * local_angular
	#

func avoid_other_ships():
	pass
	for ally in allies:
		if not is_instance_valid(ally) or ally == self:
			continue
		var diff = ally.global_position - global_position
		var length = diff.length()
		apply_central_force((diff / length) * (length - 200))
	for enemy in enemies:
		if not is_instance_valid(enemy):
			continue
		var diff = enemy.global_position - global_position
		var length = diff.length()
		apply_central_force((diff / length) * (length - 200))
		


func select_forward_target():
	# only select a new target randomly every 10 seconds
	if is_instance_valid(target) and Time.get_ticks_msec() - target_selection_time < TIME_TO_REEVALUATE_TARGET_MS:
		return
	
	target_selection_time = Time.get_ticks_msec()

	if len(enemies) == 0:
		target = null
		return

	var best_target = null
	var best_score = -999999999
	for candidate in enemies:
		if not is_instance_valid(candidate):
			continue
		var candidate_score = score_target(candidate)
		if candidate_score > best_score:
			best_score = candidate_score
			best_target = candidate

	target = best_target

func score_target(t:RigidBody3D) -> float:
	#var expected_position = HelperFunctions.compute_expected_target_position(global_position, linear_velocity, BULLET_INITIAL_SPEED, t.global_position, t.linear_velocity)
	var local_pos = transform * t.global_position
	
	#if local_pos.dot(Vector3.FORWARD) < 0.25: #can't even point at this target
		#return 0
	
	#score is just negative distance, to prioritize closer targets
	return -local_pos.length_squared() + local_pos.dot(Vector3.FORWARD) * 1000


func destroy():
	# attach any child ShipModules to the root so that they remain present in the game
	var new_parent = get_tree().get_current_scene()
	var children = get_children()

	for child in children:
		if child is ShipModule:
			# ensure that the objects maintain their original transforms
			var old_transform = child.global_transform
			remove_child(child)
			new_parent.add_child(child)
			child.global_transform = old_transform
			
			# give each child a slight kick
			child.linear_velocity += Vector3(randfn(0, 1), randfn(0, 1), randfn(0, 1))
			child.angular_velocity += Vector3(randfn(0, 1), randfn(0, 1), randfn(0, 1)) * 0.25

	queue_free() # safely remove the parent from the scene
