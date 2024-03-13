extends Node
class_name AudioController

var hitloop: AudioStreamPlayer
@export var HITLOOP_PLAY_VOLUME = -40
@export var HITLOOP_SILENCE_VOLUME = -80

var cannon: AudioStreamPlayer
@export var CANNON_PLAY_VOLUME = -32
@export var CANNON_SILENCE_VOLUME = -80

var soundtrack: AudioStreamPlayer


func _ready():
	hitloop = $HitLoop
	hitloop.stream.loop = true
	hitloop.volume_db = HITLOOP_SILENCE_VOLUME
	
	cannon = $Cannon
	cannon.stream.loop = true
	cannon.volume_db = CANNON_SILENCE_VOLUME
	
	soundtrack = $Soundtrack
	soundtrack.stream.loop = true

func _physics_process(delta):
	hitloop.volume_db += (HITLOOP_SILENCE_VOLUME - hitloop.volume_db) * delta
	
	if Input.is_action_pressed('space') and not GameMaster.game_over:
		#get_hit()
		cannon.volume_db += (CANNON_PLAY_VOLUME - cannon.volume_db) * delta * 50
	else:
		cannon.volume_db += (CANNON_SILENCE_VOLUME - cannon.volume_db) * delta * 20

func get_hit():
	hitloop.volume_db = HITLOOP_PLAY_VOLUME
