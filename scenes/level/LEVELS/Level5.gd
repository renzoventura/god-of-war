extends "res://scenes/level/TemplateLevel.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


func _ready():
	play_sad_music()


func play_sad_music():
	BackgroundMusic.play_sad_music()


func _on_Gate_body_entered(body):
	if(body.name == "Player"):
		var _change_scene = get_tree().change_scene("res://scenes/level/LEVELS/Level6.tscn")
	pass # Replace with function body.

