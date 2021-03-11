extends Sprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var defaultPreload = preload("res://assets/environment/blue.png")
var defaultPreload1 = preload("res://assets/environment/default.png")
var defaultPreload2 = preload("res://assets/environment/green.png")
var defaultPreload3 = preload("res://assets/environment/red.png")
var list_sprites = [defaultPreload, defaultPreload1, defaultPreload2, defaultPreload3]
# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	texture = defaultPreload1
	var random_value = int(rand_range(-360, 360))
	rotation_degrees = random_value
	if(random_value % 2 == 1):
		flip_h = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
