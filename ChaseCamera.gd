extends RigidBody3D

@export var target: CameraTarget
var target_parent: Node3D

@export var spring: float = 15.0
@export var damping: float = 20

# Called when the node enters the scene tree for the first time.
func _ready():
	# get the target_parent
	target_parent = target.get_parent()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _physics_process(delta):

	# apply the spring force
	apply_central_force(spring*spring * (target.get_global_transform().origin - global_transform.origin))
	
	# apply the damping force
	apply_central_force(-damping * linear_velocity)

	# align the camera frame with the target_parent's frame
	transform.basis = target_parent.get_global_transform().basis
	#TODO: two things:
	#      - this should look at where the target is going based on its velocity
	#      - instead of snapping the basis to exactly be the target's, it could also be spring/damper based
