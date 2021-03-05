extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var motion = Vector2(0,0)
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



func _process(delta):
	move()
	move_and_slide(motion)
	
func move():
	motion.x = 10

func _on_Area2D_body_entered(body):
	print(body.name)
	pass # Replace with function body.


func _on_Area2D_area_entered(area):
	if (area.name == "SwordArea"):
		print("HIT!");
