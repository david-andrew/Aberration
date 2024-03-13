extends Node




func _ready():
	$AnimationPlayer.play("TitleAnimation")


func hide_elements():
	$CanvasLayer/Title.label_settings.font_color = Color(0,0,0,0)
	$CanvasLayer/ContinueButton.modulate = Color(0,0,0,0)
	$CanvasLayer/Title/TextureRect.modulate = Color(0,0,0,0)
	$CanvasLayer/Title/TextureRect2.modulate = Color(0,0,0,0)
