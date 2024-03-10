extends ShipModule
@export var MAX_POWER_STORAGE: int = 100
@export var POWER_REGEN_RATE: float = 1.0 # units per second
var current_power_storage: float = 0.5 * MAX_POWER_STORAGE


func _physics_process(delta):
	if current_power_storage < MAX_POWER_STORAGE:
		current_power_storage += POWER_REGEN_RATE * delta
