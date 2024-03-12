extends ShipModule

@export var POWER_DRAW = 10 #units per second

var power_modules: Array[PowerModule]
var laser
var command_shoot: bool = true
var original_parent
var last_try_had_enough_power:bool=false

func _ready():
	super._ready()
	# get a list of sibling power connectors
	var parent = get_parent()
	for child in parent.get_children():
		if child is PowerModule:
			power_modules.append(child)
			
	laser = $RayCast3D
	
	original_parent = get_parent()

func shoot(physics_delta):
	#DEBUG, for now don't use lasers
	laser.visible = false
	return
	
	
	#only try to shoot again after a random number of frames
	if not last_try_had_enough_power and randf() < 0.9:
		return
	
	# randomly select a battery from the list to draw power from (ensuring it is valid and a a sibling)
	# go through all in list until we find one. otherwise deactivate firing
	# if firing active, take an amount of power from the battery
	var shot_power_usage = POWER_DRAW * physics_delta;
	
	
	power_modules.shuffle()
	var power_taken: float = 0.0
	var can_shoot:bool = false
	for module in power_modules:
		if is_instance_valid(module) and module.get_parent() == original_parent and module.current_power_storage > shot_power_usage:
			power_taken += module.take_power(shot_power_usage - power_taken)
			if is_equal_approx(shot_power_usage, power_taken):
				can_shoot = true
				break
	
	laser.visible = can_shoot
	last_try_had_enough_power = can_shoot
	if not can_shoot and power_taken > 0:
		#distribute any unused power to all the batteries
		for module in power_modules:
			if is_instance_valid(module) and module.get_parent() == original_parent:
				module.add_power(power_taken / power_modules.size())
				

func _physics_process(delta):
	if command_shoot:
		shoot(delta)
	else:
		laser.visible = false
