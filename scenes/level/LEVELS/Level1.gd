extends "res://scenes/level/TemplateLevel.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Gate_area_entered(area):
	pass # Replace with function body.


func _on_Gate_body_entered(body):
	if(body.name == "Player"):
		get_tree().change_scene("res://scenes/level/LEVELS/Level1.tscn")
	pass # Replace with function body.
