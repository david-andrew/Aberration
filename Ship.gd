extends RigidBody3D


# DEBUG
@export var health: Health

# throttle
#var throttle = 0
#const max_throttle = 2
#const min_throttle = -0.5
#const d_throttle = 0.1

const translation_strength = 1.0
const rotation_strength = 0.5


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _physics_process(delta):
	
	if Input.is_action_just_pressed('space'):
		
		health.damage(1)
	# debug display throttle and x,y,z velocity (relative to self)
	#print("throttle: ", throttle, ", velocity: ", linear_velocity)
	
	# # translate forward
	# if Input.is_action_pressed("w"):
	# 	apply_impulse(Vector3(0, 0, -1) * delta)

	# # translate backward
	# if Input.is_action_pressed("s"):
	# 	apply_impulse(Vector3(0, 0, 1) * delta)

	## Translations ##
	# translate left
	if Input.is_action_pressed("a"):
		apply_impulse(-global_transform.basis.x * delta * translation_strength)

	# translate right
	if Input.is_action_pressed("d"):
		apply_impulse(global_transform.basis.x * delta * translation_strength)

	# translate up
	if Input.is_action_pressed("w"):
		apply_impulse(global_transform.basis.y * delta * translation_strength)
	
	# translate down
	if Input.is_action_pressed("s"):
		apply_impulse(-global_transform.basis.y * delta * translation_strength)

	# throttle
	if Input.is_action_pressed("shift"):
		#throttle = min(throttle + d_throttle * delta, max_throttle)
		apply_impulse(-global_transform.basis.z * delta * translation_strength*5)
		
	if Input.is_action_pressed("ctrl"):
		#throttle = max(throttle - d_throttle * delta, min_throttle)
		apply_impulse(global_transform.basis.z * delta * translation_strength)
	#if Input.is_action_just_pressed('space'):
		#throttle = 0
	# apply throttle
	#apply_impulse(-global_transform.basis.z * throttle * delta)


	## Rotations ##
	# rotate +x
	if Input.is_action_pressed("down"):
		apply_torque_impulse(global_transform.basis.x * delta * rotation_strength)

	# rotate -x
	if Input.is_action_pressed("up"):
		apply_torque_impulse(-global_transform.basis.x * delta * rotation_strength)
	
	# rotate +y
	if Input.is_action_pressed("left"):
		apply_torque_impulse(global_transform.basis.y * delta * rotation_strength)

	# rotate -y
	if Input.is_action_pressed("right"):
		apply_torque_impulse(-global_transform.basis.y * delta * rotation_strength)

	# rotate +z
	if Input.is_action_pressed("q"):
		apply_torque_impulse(global_transform.basis.z * delta * rotation_strength)

	# rotate -z
	if Input.is_action_pressed("e"):
		apply_torque_impulse(-global_transform.basis.z * delta * rotation_strength)
