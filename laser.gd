extends RayCast3D

@onready var beam_mesh = $MeshInstance3D

@onready var endpoint_mesh = $endpoint

#export var MAX_DISTANCE:int = 10000

func _physics_process(delta):
	var cast_point
	force_raycast_update()

	if is_colliding():	
		cast_point = to_local(get_collision_point())
	else:
		cast_point = target_position
	#else:
		#beam_mesh.visible = false
		#endpoint_mesh.visible = false

	
	beam_mesh.mesh.height = cast_point.z
	beam_mesh.position.z = beam_mesh.mesh.height / 2
	beam_mesh.visible = true
	endpoint_mesh.visible = true
	endpoint_mesh.transform.origin = cast_point
