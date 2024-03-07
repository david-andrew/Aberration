extends MeshInstance3D

const MAX_SCALE = 5
const SCALE_STEP = 0.5

func _physics_process(delta):
	if scale.x < MAX_SCALE:
		scale += Vector3.ONE * SCALE_STEP
	else:
		queue_free()
