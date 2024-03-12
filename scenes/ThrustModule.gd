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

func point_towards(target:Vector3, delta:float):
	if not original_parent.visible:
		return
	
	if get_parent() != original_parent:
		return
	#var current_orientation = global_transform.basis
	#var target_orientation = (global_transform.origin - target).normalized()
	var relative_diff = (target - original_parent.global_transform.origin)
	#relative_diff += Vector3(randfn(0,1), randfn(0,1), randfn(0,1)) * relative_diff.length_squared() / 1000000
	#var target_dir = (target - original_parent.global_transform.origin).normalized()
	var target_dir = relative_diff.normalized()
	var current_dir = -original_parent.global_transform.basis.z.normalized()

	var angle = acos(clamp(current_dir.dot(target_dir), -1, 1))
	var axis = current_dir.cross(target_dir).normalized()
	print('rotation angle ', angle)
	if angle > 0.01:
		var rotation_amount = min(angle, 0.1 * delta)#rotation_speed * delta)
		var rot = Quaternion(axis, rotation_amount)
		original_parent.global_transform.basis = Basis(rot) * original_parent.global_transform.basis
#
#func point_towards(target:Vector3, strength:float=1.0):
	###DEBUG
	#if not original_parent.visible:
		#return
	#
	#if get_parent() != original_parent:
		#return
		#
	#var relative_diff = target * original_parent.global_transform
	#var distance = relative_diff.length()
	#original_parent.look_at(target, original_parent.basis.y)
	### get target in local coordinates
	##var local_target_dir = relative_diff.normalized()
	##
	###TODO: maye these proportional to the angle difference
	##var dir_xz = Vector3(local_target_dir.x, 0, local_target_dir.z)
	##var y_strength = -Vector3.FORWARD.dot(dir_xz)/2 + 0.5
	##if Vector3.LEFT.dot(local_target_dir) > 0:
		###print('positive rotation around Y ', y_strength)
		##original_parent.add_constant_torque(original_parent.basis * Vector3.UP * ROTATION_STRENGTH*y_strength)
	##else:
		###print('negative rotation around Y ', y_strength)
		##original_parent.add_constant_torque(original_parent.basis * Vector3.DOWN * ROTATION_STRENGTH*y_strength)		
	##var dir_yz = Vector3(0, local_target_dir.y, local_target_dir.z)
	##var x_strength = -Vector3.FORWARD.dot(dir_yz)/2 + 0.5
	##if Vector3.UP.dot(local_target_dir) > 0:
		###print('positive rotation around x ', x_strength)
		##original_parent.add_constant_torque(original_parent.basis * Vector3.RIGHT * ROTATION_STRENGTH * x_strength)
	##else:
		###print('negative rotation around x ', x_strength)
		##original_parent.add_constant_torque(original_parent.basis * Vector3.LEFT * ROTATION_STRENGTH * x_strength)
		##

func translate_towards(target:Vector3, strength:float=1.0):
	if get_parent() != original_parent:
		return
	var relative_diff = target - original_parent.global_position
	original_parent.apply_central_force(relative_diff.normalized() * TRANSLATION_STRENGTH * strength)
	
func thrust_forward(strength:float=1.0):
	if get_parent() != original_parent:
		return
	original_parent.apply_central_force(original_parent.basis *  Vector3.FORWARD * strength * THRUST_STRENGTH)
