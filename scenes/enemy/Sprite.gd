extends Sprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var animation_player = $"AnimationPlayer"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass



func _on_SlowBigEnemy_animate_hurt():
	animation_player.play("hurt")



func _on_SlowBigEnemy_animate_walk(is_facing_right):
	animation_player.play("walk")
	if(!is_facing_right):
		flip_h = true
	else:
		flip_h = false
