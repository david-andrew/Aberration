extends CanvasLayer

var camera: Camera3D
var player: Player
var teamid: TeamID

var enemies: Array[RigidBody3D]
var enemy_rects: Array[ColorRect]
var enemy_dists: Array[Label]
var allies: Array[RigidBody3D]
var ally_rects: Array[ColorRect]
var ally_dists: Array[Label]

var label_settings: LabelSettings

#DEBUG:
#var largetship7: ShipCore

func _ready():
	camera = GameMaster.current_scene.find_child("ChaseCamera").find_child("Camera3D")
	player = GameMaster.current_scene.find_child("Player")
	teamid = player.find_child("TeamID")
	enemies = teamid.get_all_enemy_units()
	allies = teamid.get_all_allied_units()
	
	#label_settings = $TemplateDistanceLabel.label_settings
	
	for enemy in enemies:
		#create new color rects for each ship to track
		var rect = ColorRect.new()
		add_child(rect)
		rect.color = Color.RED
		rect.size = Vector2(7,7)
		rect.position = get_screen_position_or_edge(enemy.global_position, camera.global_basis * Vector3.FORWARD, camera.global_position)
		rect.rotation = PI / 4
		enemy_rects.append(rect)
		
		var dist_label = $TemplateDistanceLabel.duplicate()
		dist_label.visible = true
		add_child(dist_label)
		enemy_dists.append(dist_label)
		dist_label.position = rect.position

	for ally in allies:
		if ally == player:
			continue
		#create new color rects for each ship to track
		var rect = ColorRect.new()
		add_child(rect)
		rect.color = Color.GREEN
		rect.size = Vector2(7,7)
		rect.position = get_screen_position_or_edge(ally.global_position, camera.global_basis * Vector3.FORWARD, camera.global_position)
		rect.rotation = PI / 4
		ally_rects.append(rect)
		
		var dist_label = $TemplateDistanceLabel.duplicate()
		dist_label.visible = true
		add_child(dist_label)
		ally_dists.append(dist_label)
		dist_label.position = rect.position

	
	
func _physics_process(_delta):
	var camera_forward = camera.global_basis * Vector3.FORWARD
	for i in range(len(enemy_rects)):
		var enemy = enemies[i]
		var rect = enemy_rects[i]
		var dist_label = enemy_dists[i]
		if not is_instance_valid(enemy):
			rect.visible = false
			dist_label.visible = false
			continue
		rect.visible = true
		rect.position = get_screen_position_or_edge(enemy.global_position, camera_forward, camera.global_position)
		dist_label.position = rect.position + Vector2(-30, -15)
		dist_label.text = str((enemy.global_position - camera.global_position).length() as int)
		
	for i in range(len(ally_rects)):
		var ally = allies[i]
		var rect = ally_rects[i]
		var dist_label = ally_dists[i]
		if not is_instance_valid(ally):
			rect.visible = false
			dist_label.visible = false
			continue
		rect.visible = true
		rect.position = get_screen_position_or_edge(ally.global_position, camera_forward, camera.global_position)
		dist_label.position = rect.position + Vector2(-30, -15)
		dist_label.text = str((ally.global_position - camera.global_position).length() as int)


	
func get_screen_position_or_edge(world_position:Vector3, camera_forward:Vector3, camera_position:Vector3):
	var screen_position = camera.unproject_position(world_position)
	var viewport_rect = camera.get_viewport().get_visible_rect()
	
	# move points behind the player to the edge of the screen
	if (world_position - camera_position).dot(camera_forward) < 0:
		screen_position.x = closest_value(screen_position.x, 10, viewport_rect.end.x-10)
		screen_position.y = closest_value(screen_position.y, 10, viewport_rect.end.y-10)
		#return screen_position
	# move points outside of the screen (but in front of the player) to the edges
	elif not viewport_rect.has_point(screen_position):
		screen_position.x = clamp(screen_position.x, 10, viewport_rect.end.x-10)
		screen_position.y = clamp(screen_position.y, 10, viewport_rect.end.y-10)

	return screen_position
	

	
	#return screen_position
	#$ColorRect.position = screen_position
	#
	## get a screen position or edge of screen for the target indicators
	#if viewport_rect.has_point(screen_position):
		#return screen_position
	#else:
		#screen_position.x = clamp(screen_position.x, 0, viewport_rect.size.x)
		#screen_position.y = clamp(screen_position.y, 0, viewport_rect.size.y)
		#return screen_position

func closest_value(input: float, value1: float, value2: float) -> float:
	var diff1 = abs(input - value1)
	var diff2 = abs(input - value2)
	if diff1 < diff2:
		return value1
	else:
		return value2
