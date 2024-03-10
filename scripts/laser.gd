extends RayCast3D

@onready var beam_mesh = $MeshInstance3D
@onready var endpoint_mesh = $endpoint

#var laser_firing = false #TODO

func _ready():
	enabled = false #only use force_raycast_update
	visible = true # debug testing

func _physics_process(delta):
	if not visible: #visibility determines if active or not
		return
	
	var cast_point
	var health: Health = null
	force_raycast_update()
	var collider = get_collider()
	if collider: 
		cast_point = to_local(get_collision_point())
		
		# get health object attached to colliding object, if present
		health = collider.get_node_or_null('Health')
		if not (health is Health): # in case someone attaches a health node that doesn't inherit from Health
			health = null
	else:
		cast_point = target_position


		
	#print('laser colliding with: ', collider)

	# drawing the laser/mesh
	beam_mesh.mesh.height = cast_point.z
	beam_mesh.position.z = beam_mesh.mesh.height / 2
	beam_mesh.visible = true
	endpoint_mesh.visible = true
	endpoint_mesh.transform.origin = cast_point


	# handle if colliding with something that has a child with Health.tscn attached
	if health:
		health.damage(1)

