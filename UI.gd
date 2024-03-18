extends Node




func _ready():
	$AnimationPlayer.play("TitleAnimation")


func hide_elements():
	$CanvasLayer/Title.modulate = Color(0,0,0,0)
	$CanvasLayer/ContinueButton.modulate = Color(0,0,0,0)
