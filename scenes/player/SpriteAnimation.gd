extends Sprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var animation_player = $SpritePlayer
onready var footSteps = $"FootSteps"

var pitch_scales = [0.9, 1.0, 1.2, 1.4]
func _ready():
	pass # Replace with function body.

func _on_Player_animate_walk(motion, is_facing_right):
	if is_facing_right:
		flip_h = false
	else:
		flip_h = true
	if(round(motion.x) != 0 or round(motion.y) != 0):
		animation_player.play("Walk")
	else:
		animation_player.play("idle")

func _on_Player_animate_hurt():
	animation_player.play("hurt")

func _on_Player_animate_dodge():
	animation_player.play("dash")


func foot_step_effect():
	if(!footSteps.playing):
		footSteps.pitch_scale = pitch_scales[randi() % pitch_scales.size()] + 1
		footSteps.play()
