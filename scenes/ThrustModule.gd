extends ShipModule
class_name ThrustModule


@export var TRANSLATION_STRENGTH:float = 500
@export var ROTATION_STRENGTH:float = 2
@export var THRUST_STRENGTH:float = 1000

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
	var relative_diff = target - original_parent.global_position
	original_parent.apply_central_force(relative_diff.normalized() * TRANSLATION_STRENGTH * strength)
	
func thrust_forward(strength:float=1.0):
	if get_parent() != original_parent:
		return
	original_parent.apply_central_force(original_parent.basis *  Vector3.FORWARD * strength * THRUST_STRENGTH)
