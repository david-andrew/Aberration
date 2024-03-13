extends Node
class_name GameMasterClass



const MAX_BULLETS = 1000
var total_bullets = 0 #keep track of the number of bullets in the scene
var bullet_id = 0     #keep track of unique ids for bullets
var current_scene = null
var game_over: bool = false
var animator: AnimationPlayer
var ui
var continue_button: Button

#const PLAYER = preload("res://scenes/player.tscn")
var player: Player
#var chase_camera: ChaseCamera


func _ready():
	if current_scene == null:
		var root = get_tree().get_root()
		current_scene = root.get_child(root.get_child_count() - 1)

	animator = current_scene.find_child('AnimationPlayer')
	
	# link up the UI, and especially the continue button signal
	ui = current_scene.find_child('UI')
	continue_button = ui.find_child('CanvasLayer').find_child("ContinueButton")
	continue_button.connect("pressed", do_continue_game)
	
	#chase_camera = current_scene.find_child("ChaseCamera")
	player = current_scene.find_child("Player")

func set_current_scene(scene):
	current_scene = scene

func do_game_over():
	game_over = true
	continue_button.disabled = false
	animator.play("ContinueFadeIn")
	
func do_continue_game():
	game_over = false
	ui.hide_elements()
	continue_button.disabled = true
	
	player.reset_player()
	
	#create a new instance of the player and add them to the scene
	#var player = PLAYER.instantiate()
	#current_scene.add_child(player)
	#player.global_transform = chase_camera.global_transform
	#
	## reset the chase camera to the new player
	#chase_camera.player = player
	#chase_camera.target = player.find_child("CameraTarget")
	#chase_camera.prev_test_position = chase_camera.global_position

func _physics_process(_delta):
	if total_bullets > MAX_BULLETS:
		cull_bullets()

func add_bullet() -> int:
	total_bullets += 1
	bullet_id += 1
	return bullet_id

func remove_bullet():
	total_bullets -= 1

func cull_bullets():
	if total_bullets <= MAX_BULLETS:
		return

	var min_bullet_id = bullet_id - MAX_BULLETS
	for child in current_scene.get_children():
		if total_bullets <= MAX_BULLETS:
			break
		if not (child is Bullet):
			continue
		var bullet := child as Bullet
		if bullet.id < min_bullet_id:
			bullet.queue_free()
			total_bullets -= 1
