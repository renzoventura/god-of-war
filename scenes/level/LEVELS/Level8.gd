extends "res://scenes/level/TemplateLevel.gd"

func _ready():
	pass # Replace with function body.

func _on_Gate_body_entered(body):
	if(body.name == "Player"):
		print("THANK YOU FOR PLAYING")

func on_death():
	get_tree().change_scene("res://scenes/level/LEVELS/Level7.tscn")
