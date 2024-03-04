extends RigidBody3D

@export var target: CameraTarget
var target_parent: Node3D

@export var spring: float = 20.0
@export var damping: float = 5

# Called when the node enters the scene tree for the first time.
func _ready():
	# get the target_parent
	target_parent = target.get_parent()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _physics_process(delta):
	# calculate the distance between the camera and the target
	#var distance = target.get_global_transform().origin.distance_to(global_transform.origin)

	# apply the spring force
	apply_central_force(spring * (target.get_global_transform().origin - global_transform.origin))
	
	# apply the damping force
	apply_central_force(-damping * linear_velocity)

	# look at the target
	look_at(target_parent.get_global_transform().origin, Vector3(0, 1, 0))
