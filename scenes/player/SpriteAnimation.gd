extends Sprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var animation_player = $SpritePlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Player_animate_walk(motion, is_facing_right):
	if is_facing_right:
		flip_h = false
	else:
		flip_h = true
	if(round(motion.x) != 0 or round(motion.y) != 0):
		print(motion)
		animation_player.play("Walk")
	else:
		animation_player.play("idle")


func _on_Player_animate_hurt():
	animation_player.play("hurt")

