extends RigidBody3D
class_name ShipCore

@export var player_controlled: bool = false

func destroy():
	# attach any child ShipModules to the root so that they remain present in the game
	var new_parent = get_tree().get_current_scene()
	var children = get_children()

	for child in children:
		if child is ShipModule:
			# ensure that the objects maintain their original transforms
			var old_transform = child.global_transform
			remove_child(child)
			new_parent.add_child(child)
			child.global_transform = old_transform

	queue_free() # safely remove the parent from the scene
