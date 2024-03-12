extends ShipModule
class_name ThrustModule


@export var TRANSLATION_STRENGTH:float = 100
@export var ROTATION_STRENGTH:float = 2
@export var THRUST_MULTIPLIER:float = 5

var original_parent:RigidBody3D

func _ready():
	original_parent = get_parent()
	super.link_module_to_core()

func point_towards(target:Vector3, strength:float=1.0):
	if get_parent() != original_parent:
		return
	original_parent.look_at(target, Vector3.UP, true)

func translate_towards(target:Vector3, strength:float=1.0):
	if get_parent() != original_parent:
		return
	var local_direction = to_local(target).normalized()
	original_parent.apply_central_force(Vector3(local_direction.x, local_direction.y, local_direction.z*THRUST_MULTIPLIER) * TRANSLATION_STRENGTH * strength)
