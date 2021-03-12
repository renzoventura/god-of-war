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
		var _change_scene = get_tree().change_scene("res://scenes/level/LEVELS/Level5.tscn")
	pass # Replace with function body.


func _on_Enemies_open_gate():
	pass # Replace with function body.
