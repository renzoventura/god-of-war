extends AnimationPlayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_RangeEnemy_animate_hurt():
	play("hurt")


func _on_RangeEnemy_animate_walk(is_facing_right):
	get_parent().flip_h = !is_facing_right 
	play("idle")
