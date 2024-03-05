extends CollisionShape3D

@export var health_component: Health


## Called when the node enters the scene tree for the first time.
#func _ready():
	#pass # Replace with function body.
#
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#pass


func damage(pts:int):
	if health_component:
		health_component.damage(pts)
