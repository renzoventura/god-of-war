extends "res://scenes/enemy/Enemy.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var sprite = $Sprite
var color_damage = 5
# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	health = 100
	maxhealth = 100
	isntanced_position = global_position;
	healthText.text = generate_health_string()
	set_up_health_bar()
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func hurt():
	sprite.modulate = Color(color_damage,color_damage,color_damage)

func idle_feature():
	sprite.modulate = Color(1,1,1)
