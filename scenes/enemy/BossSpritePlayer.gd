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


func _on_BossEnemy_animate_idle(is_facing_right):
	play("Idle")
	if(!is_facing_right):
		get_parent().flip_h = true
	else:
		get_parent().flip_h = false

