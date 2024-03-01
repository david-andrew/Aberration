extends RigidBody3D

# throttle
var throttle = 0
var max_throttle = 2
var min_throttle = -0.5
var d_throttle = 0.1


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# debug display throttle and x,y,z velocity (relative to self)
	print("throttle: ", throttle, "velocity: ", linear_velocity)

	pass


func _physics_process(delta):
	# # translate forward
	# if Input.is_action_pressed("w"):
	# 	apply_impulse(Vector3(0, 0, -1) * delta)

	# # translate backward
	# if Input.is_action_pressed("s"):
	# 	apply_impulse(Vector3(0, 0, 1) * delta)

	# translate left
	if Input.is_action_pressed("a"):
		apply_impulse(Vector3(-1, 0, 0) * delta)

	# translate right
	if Input.is_action_pressed("d"):
		apply_impulse(Vector3(1, 0, 0) * delta)

	# translate up
	if Input.is_action_pressed("w"):
		apply_impulse(Vector3(0, -1, 0) * delta)
	
	# translate down
	if Input.is_action_pressed("s"):
		apply_impulse(Vector3(0, 1, 0) * delta)

	# throttle
	if Input.is_action_pressed("shift"):
		throttle = min(throttle + d_throttle * delta, max_throttle)
	if Input.is_action_pressed("ctrl"):
		throttle = max(throttle - d_throttle * delta, min_throttle)

	# apply throttle
	apply_impulse(Vector3(0, 0, -1) * throttle * delta)
