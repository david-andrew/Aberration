extends ShipModule


func _ready():
	# shield needs to be linked to all siblings rathar than just the parent, 
	# 1. so it is better locked in place
	# 2. so the shield doesn't interfere with any of the internal rigidbodies of the ship
	link_module_to_siblings()
