extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


var is_adding = false
func _process(_delta):
	rotation_degrees = rotation_degrees - 5;
	update_rotation()
		
func update_rotation():
	if(abs(rotation_degrees) > 359): 
		rotation_degrees = 0
#	print(rotation_degrees)
