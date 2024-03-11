extends RigidBody3D

@export var target: CameraTarget
var target_parent: Node3D

@export var spring: float = 100
@export var damping: float = 400

var test_velocity: Vector3 = Vector3.ZERO
var prev_test_position: Vector3 = Vector3.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	# get the target_parent
	target_parent = target.get_parent()
	
	prev_test_position = global_position
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _physics_process(delta):
	
	
	test_velocity = global_position - prev_test_position
	prev_test_position = global_position

	#return early if target instance is no longer valid
	if !is_instance_valid(target):
		apply_central_force(-damping/20 * test_velocity)
		return

	# apply the spring force
	var distance = target.get_global_transform().origin - global_transform.origin
	apply_central_force(spring * distance) #distance.length_squared() * distance.normalized())
	
	# apply the damping force
	apply_central_force(-damping * (test_velocity - target.linear_velocity))
	#print('delta velocity: ', linear_velocity - target.linear_velocity)
	#print('global velocity vs linear velocity: ', (linear_velocity - test_velocity))

	# align the camera frame with the target's frame #target_parent's frame
	transform.basis = target.global_transform.basis
	#TODO: two things:
	#      - this should look at where the target is going based on its velocity
	#      - instead of snapping the basis to exactly be the target's, it could also be spring/damper based
