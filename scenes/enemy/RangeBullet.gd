extends RigidBody2D

var direction : Vector2 = Vector2.LEFT
var speed : float = 300 

func _ready():
	pass

func _process(delta):
	translate(direction*speed*delta)


func _on_Area2D_area_entered(area):
	if(area.name == "Player" || area.name == "TileMap"):
		print("BULLET HIT PLAYER/TILE AREA or ")
		queue_free()


func _on_Area2D_body_entered(body):
	if(body.name == "Player" || body.name == "TileMap"):
		print("BULLET HIT PLAYER/TILE BODY")
		queue_free()
