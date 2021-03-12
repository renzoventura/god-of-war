extends "res://scenes/level/TemplateLevel.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Gate_area_entered(area):
	pass # Replace with function body.


func _on_Gate_body_entered(body):
	if(body.name == "Player"):
		get_tree().change_scene("res://scenes/level/LEVELS/Level2.tscn")
	pass # Replace with function body.

func play_music():
	BackgroundMusic.play_tutorial_music()
