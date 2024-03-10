extends Damager
class_name Bullet

#var bullet: int
var id: int

const EXPLOSION = preload("res://scenes/bullet_explosion.tscn")

func give_damage() -> int:
	# add explosion to the scene where the bullet was when it hit
	var explosion = EXPLOSION.instantiate()
	GameMaster.current_scene.add_child(explosion)
	explosion.position = global_position
	
	# remove the bullet from the game
	GameMaster.remove_bullet()
	queue_free()
	
	return 10

func _ready():
	id = GameMaster.add_bullet()
