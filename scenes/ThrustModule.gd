extends ShipModule
class_name ThrustModule


@export var TRANSLATION_STRENGTH:float = 500
@export var ROTATION_STRENGTH:float = 100
@export var THRUST_STRENGTH:float = 1000

var original_parent:RigidBody3D

func _ready():
	original_parent = get_parent()
	assert(original_parent is ShipCore, "expected thrusters to be attached to a ship core")
	super.link_module_to_core()

func point_towards(target:Vector3, strength:float=1.0):
	#DEBUG
	if not original_parent.visible:
		return
	
	if get_parent() != original_parent:
		return
	# get target in local coordinates
	var relative_diff = target * original_parent.global_transform
	var local_target_dir = relative_diff.normalized()
	
	#TODO: maye these proportional to the angle difference
	var dir_xz = Vector3(local_target_dir.x, 0, local_target_dir.z)
	var y_strength = -Vector3.FORWARD.dot(dir_xz)/2 + 0.5
	if Vector3.LEFT.dot(local_target_dir) > 0:
		#print('positive rotation around Y ', y_strength)
		original_parent.add_constant_torque(original_parent.basis * Vector3.UP * ROTATION_STRENGTH*y_strength)
	else:
		#print('negative rotation around Y ', y_strength)
		original_parent.add_constant_torque(original_parent.basis * Vector3.DOWN * ROTATION_STRENGTH*y_strength)		
	var dir_yz = Vector3(0, local_target_dir.y, local_target_dir.z)
	var x_strength = -Vector3.FORWARD.dot(dir_yz)/2 + 0.5
	if Vector3.UP.dot(local_target_dir) > 0:
		#print('positive rotation around x ', x_strength)
		original_parent.add_constant_torque(original_parent.basis * Vector3.RIGHT * ROTATION_STRENGTH * x_strength)
	else:
		#print('negative rotation around x ', x_strength)
		original_parent.add_constant_torque(original_parent.basis * Vector3.LEFT * ROTATION_STRENGTH * x_strength)
		

func translate_towards(target:Vector3, strength:float=1.0):
	if get_parent() != original_parent:
		return
	var relative_diff = target - original_parent.global_position
	original_parent.apply_central_force(relative_diff.normalized() * TRANSLATION_STRENGTH * strength)
	
func thrust_forward(strength:float=1.0):
	if get_parent() != original_parent:
		return
	original_parent.apply_central_force(original_parent.basis *  Vector3.FORWARD * strength * THRUST_STRENGTH)
