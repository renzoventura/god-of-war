extends Node2D

func _ready():
	BackgroundMusic.stop()
	pass # Replace with function body.

func _on_Gate_body_entered(body):
	if(body.name == "Player"):
		get_tree().change_scene("res://scenes/level/LEVELS/Level8.tscn")
