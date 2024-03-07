extends Damager
class_name Bullet

#var bullet: int
var id: int

const EXPLOSION = preload("res://bullet_explosion.tscn")

func give_damage() -> int:
	var explosion = EXPLOSION.instantiate()
	GameMaster.current_scene.add_child(explosion)
	explosion.position = global_position
	queue_free()
	
	return 1

func _ready():
	id = GameMaster.add_bullet()
