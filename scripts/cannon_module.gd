extends ShipModule

var target: Node3D = null
var possible_targets: Array[Node3D] = []
var original_transform: Transform3D
@export var MIN_ANGLE_WITH_SURFACE: float = PI/8
var ray: RayCast3D
var original_parent

const SHOOT_FREQUENCY = 20 #shots/second
var last_shot_time = Time.get_ticks_msec()
const BULLET_INITIAL_SPEED = 100
const BULLET = preload("res://scenes/bullet.tscn")
var total_bullets_shot = 0





func _ready():
	var joint = PinJoint3D.new()
	link_module_to_core(joint)

	# DEBUG, replace with actual target
	target = get_tree().current_scene.find_child('Player')
	original_transform = Transform3D(transform)
	
	ray = $RayCast3D
	ray.enabled = false
	ray.visible = false
	
	original_parent = get_parent()


func _physics_process(delta):
	try_shoot_at_target()


func set_targets(targets:Array[Node3D]):
	#TODO: for use by control modules
	pass

func select_best_target():
	if len(possible_targets) == 0:
		return
	if not target:
		target = possible_targets[0]
	
	#TODO: iterate over targets, select the closest (ensuring that the turret can point at it)

func try_shoot_at_target():
	if get_parent() != original_parent:
		return
	
	if not target:
		return
		
	# TODO: long term, this only seems to be correct for one orientation of turret
	#check that target is at an aimable spot
	#var dot = (original_transform.basis * (global_position - target.global_position)).normalized().dot(Vector3.FORWARD)

	# check if cannon can point at the target
	#if PI/2 - acos(dot) < MIN_ANGLE_WITH_SURFACE:
		##print('target is out of angular range')
		#transform.basis = original_transform.basis
		#return


	look_at(target.global_position, Vector3.UP)


	# check if cannon is beyond max rotation
	if transform.basis.z.dot(original_transform.basis.z) < 0.25:
		ray.visible = false
		return
	
	##draw a raycast from the turret tip and check if it collides with the player
	ray.visible = false
	ray.force_raycast_update()
	var collider = ray.get_collider()
	if not collider:
		ray.visible = false
		return
	
	#ray.visible = collider == target
	#if collider == target:
		#print('raycast hitting target ', target)
	#else:
		#print('raycast not hitting target ', target)
	
	if collider == target:
		#ray.visible = true
		shoot_bullet()
	
		
func shoot_bullet():
	if Time.get_ticks_msec() - last_shot_time > (1000 / SHOOT_FREQUENCY):
		var bullet = BULLET.instantiate()
		GameMaster.current_scene.add_child(bullet)
		bullet.global_basis = global_basis
		bullet.position = global_position + (target.global_position - global_position).normalized() * 2 + Vector3(randf(), randf(), randf()) * 0.5
		bullet.global_position -= 2*global_transform.basis.z
		bullet.linear_velocity = linear_velocity + BULLET_INITIAL_SPEED * -global_transform.basis.z + Vector3(randfn(0,1), randfn(0,1), randfn(0,1))
		last_shot_time = Time.get_ticks_msec()
		total_bullets_shot += 1

	
