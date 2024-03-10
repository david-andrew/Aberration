extends ShipModule
class_name PowerModule

@export var MAX_POWER_STORAGE: int = 100
@export var POWER_REGEN_RATE: float = 1.0 # units per second
var current_power_storage: float = 0.5 * MAX_POWER_STORAGE


func _physics_process(delta):
	if current_power_storage < 0:
		current_power_storage = 0
	if current_power_storage < MAX_POWER_STORAGE:
		add_power(POWER_REGEN_RATE * delta)


func add_power(amount: float):
	if current_power_storage < MAX_POWER_STORAGE:
		current_power_storage += amount
	#in the future, could look at overloading when too much power over MAX is added

func take_power(amount: float) -> float:
	var available = min(max(current_power_storage, 0), amount)
	current_power_storage = max(current_power_storage - amount, 0)
	return available
	
