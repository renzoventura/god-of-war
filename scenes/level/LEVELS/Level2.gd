extends "res://scenes/level/TemplateLevel.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	play_main_battle_music()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Gate_body_entered(body):
	if(body.name == "Player"):
#		print("body")
		get_tree().change_scene("res://scenes/level/LEVELS/Level3.tscn")
	pass # Replace with function body.


func _on_Gate_area_entered(area):
	if(area.name == "Player"):
#		print("area")
		get_tree().change_scene("res://scenes/level/LEVELS/Level3.tscn")
	pass # Replace with function body.

func play_main_battle_music():
	BackgroundMusic.play_battle_music()
