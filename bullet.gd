extends Damager
class_name Bullet

var bullet: int
var id: int

func give_damage() -> int:
	return 1

func _ready():
	id = GameMaster.add_bullet()
