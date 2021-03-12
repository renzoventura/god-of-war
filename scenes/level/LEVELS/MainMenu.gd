extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_StartGame_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			get_tree().change_scene("res://scenes/level/LEVELS/Level1.tscn")


func _on_StartGame_mouse_entered():
	pass # Replace with function body.


func _on_StartGame_mouse_exited():
	pass # Replace with function body.
