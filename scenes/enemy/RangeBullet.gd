extends RigidBody2D

var direction : Vector2 = Vector2.LEFT
var speed : float = 300 

func _ready():
	pass

func _process(delta):
	translate(direction*speed*delta)


func _on_Area2D_area_entered(area):
	pass # Replace with function body.
