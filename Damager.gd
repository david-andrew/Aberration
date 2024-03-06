extends Node
class_name Damager

func _ready():
	assert(get_script() != Damager, "Damager is an abstract class, and should not be instantiated directly")

func give_damage() -> int:
	push_error("give damage should be overrided by the child class extending Damager")
	return 0
