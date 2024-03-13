extends RigidBody3D
class_name Player

const translation_strength = 3.0
const rotation_strength = 0.5

enum WeaponType {BULLET, LASER}
var selected_weapon: WeaponType = WeaponType.BULLET


const SHOOT_FREQUENCY = 20 #shots/second
var last_shot_time = Time.get_ticks_msec()
const FULL_AUTOMATIC_MODE = false #false means burst mode
const BULLETS_PER_SHOT = 3 #burst mode, like halo combat rifle
const BULLET_INITIAL_SPEED = 100
# preload resource for bullets
const BULLET = preload("res://scenes/bullet.tscn")
var total_bullets_shot = 0
var bullet_count = 0

@onready var laser = $Laser
var is_dead: bool = false


# Called when the node enters the scene tree for the first time.
func _ready():
	laser.visible = false



#func _exit_tree():
	#GameMaster.do_game_over()

func destroy():
	print('calling destroy instead of exit tree')
	GameMaster.do_game_over()
	kill_player()

func kill_player():
	visible = false
	is_dead = true
	collision_layer = 10
	
func reset_player():
	is_dead = false
	visible = true
	collision_layer = 1
	$Health.health = $Health.MAX_HEALTH + 1
	$Health.damage(1)
	position += Vector3.FORWARD * 2 # make the camera spring a bit when resetting player


func shoot_bullet():
	if Time.get_ticks_msec() - last_shot_time > (1000.0 / SHOOT_FREQUENCY) and bullet_count < BULLETS_PER_SHOT:
		var bullet = BULLET.instantiate()
		GameMaster.current_scene.add_child(bullet)
		bullet.global_basis = global_basis
		bullet.position = global_position + Vector3(randf(), randf(), randf()) * 0.5
		bullet.global_position -= 2*global_transform.basis.z
		bullet.linear_velocity = linear_velocity + BULLET_INITIAL_SPEED * -global_transform.basis.z + Vector3(randf(), randf(), randf()) * 2
		last_shot_time = Time.get_ticks_msec()
		total_bullets_shot += 1
		#if !FULL_AUTOMATIC_MODE:
			#bullet_count += 1


func _physics_process(delta):


	if not is_dead and Input.is_action_pressed('space'):
		if selected_weapon == WeaponType.BULLET:
			shoot_bullet()
		if selected_weapon == WeaponType.LASER:
			laser.visible = true
	
	if not is_dead and Input.is_action_just_released('space'):
		if selected_weapon == WeaponType.BULLET:
			bullet_count = 0
		elif selected_weapon == WeaponType.LASER:
			#print('end of firing laser')
			laser.visible = false

	if not is_dead and Input.is_action_just_pressed("caps-lock"):
		selected_weapon = ((selected_weapon + 1) % WeaponType.size()) as WeaponType
		if selected_weapon != WeaponType.LASER:
			laser.visible = false
	

	## Translations ##
	# translate left
	if not is_dead and Input.is_action_pressed("a"):
		apply_impulse(-global_transform.basis.x * delta * translation_strength)

	# translate right
	if not is_dead and Input.is_action_pressed("d"):
		apply_impulse(global_transform.basis.x * delta * translation_strength)

	# translate up
	if not is_dead and Input.is_action_pressed("shift"):
		apply_impulse(global_transform.basis.y * delta * translation_strength)
	
	# translate down
	if not is_dead and Input.is_action_pressed("ctrl"):
		apply_impulse(-global_transform.basis.y * delta * translation_strength)

	# throttle
	if not is_dead and Input.is_action_pressed("w"):
		#throttle = min(throttle + d_throttle * delta, max_throttle)
		apply_impulse(-global_transform.basis.z * delta * translation_strength*3)
		
	if not is_dead and Input.is_action_pressed("s"):
		#throttle = max(throttle - d_throttle * delta, min_throttle)
		apply_impulse(global_transform.basis.z * delta * translation_strength)
	#if Input.is_action_just_pressed('space'):
		#throttle = 0
	# apply throttle
	#apply_impulse(-global_transform.basis.z * throttle * delta)


	## Rotations ##
	# rotate +x
	if not is_dead and Input.is_action_pressed("down"):
		apply_torque_impulse(global_transform.basis.x * delta * rotation_strength)

	# rotate -x
	if not is_dead and Input.is_action_pressed("up"):
		apply_torque_impulse(-global_transform.basis.x * delta * rotation_strength)
	
	# rotate +y
	if not is_dead and Input.is_action_pressed("left"):
		apply_torque_impulse(global_transform.basis.y * delta * rotation_strength)

	# rotate -y
	if not is_dead and Input.is_action_pressed("right"):
		apply_torque_impulse(-global_transform.basis.y * delta * rotation_strength)

	# rotate +z
	if not is_dead and Input.is_action_pressed("q"):
		apply_torque_impulse(global_transform.basis.z * delta * rotation_strength)

	# rotate -z
	if not is_dead and Input.is_action_pressed("e"):
		apply_torque_impulse(-global_transform.basis.z * delta * rotation_strength)
