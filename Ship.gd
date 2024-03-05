extends RigidBody3D


#var GameMaster: GameMasterClass

# DEBUG
@export var health: Health

# throttle
#var throttle = 0
#const max_throttle = 2
#const min_throttle = -0.5
#const d_throttle = 0.1

const translation_strength = 1.0
const rotation_strength = 0.5


const SHOOT_FREQUENCY = 20 #shots/second
var last_shot_time = Time.get_ticks_msec()
const FULL_AUTOMATIC_MODE = false #false means burst mode
const BULLETS_PER_SHOT = 3 #burst mode, like halo combat rifle
# preload resource for bullets
const BULLET = preload("res://bullet.tscn")
var total_bullets_shot = 0
var bullet_count = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	#GameMaster = get_node("/root/GameMaster")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func shoot():
	if Time.get_ticks_msec() - last_shot_time > (1000 / SHOOT_FREQUENCY) and bullet_count < BULLETS_PER_SHOT:
		var bullet = BULLET.instantiate()
		GameMaster.current_scene.add_child(bullet)
		bullet.global_basis = global_basis
		bullet.position = global_position
		print('spawning bullet at ', global_position)
		bullet.global_position -= 2*global_transform.basis.z
		bullet.linear_velocity = linear_velocity -100 * global_transform.basis.z
		last_shot_time = Time.get_ticks_msec()
		total_bullets_shot += 1
		#if !FULL_AUTOMATIC_MODE:
			#bullet_count += 1

func _physics_process(delta):
	
	if Input.is_action_pressed('space'):
		shoot()
	if Input.is_action_just_released('space'):
		bullet_count = 0
		
		#health.damage(1)
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
