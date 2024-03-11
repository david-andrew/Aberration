extends ShipModule

var target: Node3D = null
var original_transform: Transform3D
@export var MIN_ANGLE_WITH_SURFACE: float = PI/8


func _ready():

	var joint = PinJoint3D.new()
	link_module_to_core(joint)

	# DEBUG, replace with actual target
	target = get_tree().current_scene.find_child('Player')
	original_transform = Transform3D(transform)
	
func _physics_process(delta):
	pass
	#TODO: make the turret point at the player
	#debug_player.global_position
	try_look_at_target()


func try_look_at_target():
	if not target:
		print('target is null')
		return
		
	#check that target is at an aimable spot
	var dot = (original_transform.basis * (global_position - target.global_position)).normalized().dot(Vector3.FORWARD)

	# check if cannon can point at the target
	if PI/2 - acos(dot) < MIN_ANGLE_WITH_SURFACE:
		#print('target is out of angular range')
		transform.basis = original_transform.basis
		return

	#print('looking at target ', target.global_position)
	look_at(target.global_position, Vector3.UP)
