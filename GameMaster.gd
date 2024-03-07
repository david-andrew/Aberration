extends Node
class_name GameMasterClass



const MAX_BULLETS = 225
var total_bullets = 0 #keep track of the number of bullets in the scene
var bullet_id = 0     #keep track of unique ids for bullets
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

func add_bullet() -> int:
	total_bullets += 1
	bullet_id += 1
	return bullet_id

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
