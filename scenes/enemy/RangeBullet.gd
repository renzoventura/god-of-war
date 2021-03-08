extends RigidBody2D

var direction : Vector2 = Vector2.LEFT
var speed : float = 150

func _ready():
	pass

var is_adding = false
func _process(delta):
	translate(direction*speed*delta)
	rotation_degrees = rotation_degrees - 30;
	update_rotation()

func _on_Area2D_area_entered(area):
	if(area.name == "Player" || area.name == "TileMap"):
#		print("BULLET HIT PLAYER/TILE AREA or ")
		queue_free()


func _on_Area2D_body_entered(body):
	if(body.name == "Player" || body.name == "TileMap"):
#		print("BULLET HIT PLAYER/TILE BODY")
		queue_free()
		
func update_rotation():
	if(abs(rotation_degrees) > 359): 
		rotation_degrees = 0
