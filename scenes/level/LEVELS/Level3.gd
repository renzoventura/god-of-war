extends "res://scenes/level/TemplateLevel.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	play_main_battle_music()


func play_main_battle_music():
	BackgroundMusic.play_battle_music()

func _on_Gate_body_entered(body):
	if(body.name == "Player"):
		get_tree().change_scene("res://scenes/level/LEVELS/Level4.tscn")
	pass # Replace with function body.


