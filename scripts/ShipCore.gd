extends RigidBody3D
class_name ShipCore

@export var player_controlled: bool = false
#var teamid: TeamID
var enemies: Array[RigidBody3D] = []
var thrusters: ThrustModule

#DEBUG
var player

func _ready():
	# ensure that the teamID is the first node
	var teamID:TeamID = find_child("TeamID")
	move_child(teamID, 0)
	
	# mark targets for all turrets
	enemies = teamID.get_all_enemy_units()
	for child in get_children():
		if is_instance_valid(child) and child is CannonModule:
			child.set_targets(enemies)
			
	thrusters = $ThrustModule
	
	#DEBUG translate towards the player
	player = GameMaster.current_scene.find_child('Player')
	print('found player: ', player)

func _physics_process(delta):
	if not is_instance_valid(player):
		return
	
	if not is_instance_valid(thrusters):
		return
	#thrusters.translate_towards(player.global_position)
	#thrusters.point_towards(player.global_position)
	thrusters.thrust_forward(1.0)
	#apply_central_force(basis * Vector3.FORWARD * 1000)
	pass


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
