extends Node3D
class_name CameraTarget

var linear_velocity: Vector3 = Vector3.ZERO
var prev_position: Vector3

## Called when the node enters the scene tree for the first time.
func _ready():
	prev_position = global_position

func _physics_process(delta):
	linear_velocity = global_position - prev_position
	prev_position = global_position
	

#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#pass
