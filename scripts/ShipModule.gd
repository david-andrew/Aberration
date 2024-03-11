extends RigidBody3D
class_name ShipModule


func _ready():
	link_module_to_core()

func link_module_to_core(joint: Joint3D = null):
	var parent = get_parent()
	assert((parent is ShipCore and is_instance_valid(parent)) , "ShipModule must be a child of a valid ShipCore");

	# create a 6DoF joint, and link this node with the parent
	if joint == null:
		joint = Generic6DOFJoint3D.new()
	self.add_child(joint)
	joint.node_a = parent.get_path()
	joint.node_b = self.get_path()
	

func link_module_to_siblings():
	# for each sibling, create a 6DoF joint, and link this node with the sibling
	var parent = get_parent()
	for sibling in parent.get_children():
		if sibling is ShipModule and sibling != self:
			var joint: Generic6DOFJoint3D = Generic6DOFJoint3D.new()
			self.add_child(joint)
			joint.node_a = sibling.get_path()
			joint.node_b = self.get_path()
