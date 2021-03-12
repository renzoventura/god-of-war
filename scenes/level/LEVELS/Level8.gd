extends "res://scenes/level/TemplateLevel.gd"

func _ready():
	play_music()

func _on_Gate_body_entered(body):
	if(body.name == "Player"):
		print("THANK YOU FOR PLAYING")

func on_death():
	get_tree().change_scene("res://scenes/level/LEVELS/Level7.tscn")

func play_music():
	BackgroundMusic.play_boss_music()
