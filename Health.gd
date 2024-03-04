extends Node
class_name Health

@export var MAX_HEALTH: int = 10
@export var MESH: MeshInstance3D

var MATERIAL: StandardMaterial3D
var health: int
var initial_color: Color

# Called when the node enters the scene tree for the first time.
func _ready():
	health = MAX_HEALTH
	if MESH:
		MATERIAL = MESH.get_active_material(0)
	
	if MATERIAL:
		initial_color = MATERIAL.albedo_color

func damage(pts: int):
	health -= pts
	print('health is: ', health)

	# interpolate the color based on the health
	if MATERIAL:
		MATERIAL.albedo_color = initial_color.lerp(Color(0, 0, 0), 1.0 - (float(health-1)/(MAX_HEALTH-1)))
		print('color is: ', MATERIAL.albedo_color)
	
	if health <= 0:
		get_parent().queue_free()
