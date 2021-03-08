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


func _on_BasherEnemy_animate_bashing():
	play("bash")
	pass # Replace with function body.


func _on_BasherEnemy_animate_hurt():
	play("hurt")
	pass # Replace with function body.


func _on_BasherEnemy_animate_idle():
	play("idle")
	pass # Replace with function body.
