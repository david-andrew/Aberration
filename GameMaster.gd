extends Node
class_name GameMasterClass



const MAX_BULLETS = 225
var total_bullets = 0 #keep track of the number of bullets in the scene
var current_scene = null


func _ready():
	if current_scene == null:
		var root = get_tree().get_root()
		current_scene = root.get_child(root.get_child_count() - 1)

func set_current_scene(scene):
	current_scene = scene


func _physics_process(delta):
	if total_bullets > MAX_BULLETS:
		cull_bullets()

func cull_bullets():
	for child in current_scene.get_children():
		if total_bullets <= MAX_BULLETS:
			break
		if child.get_filename() == "res://bullet.tscn":
			child.destroy()
