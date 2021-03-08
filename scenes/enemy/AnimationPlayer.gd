extends AnimationPlayer

func _ready():
	pass # Replace with function body.

func _on_RangeEnemy_animate_hurt():
	play("hurt")


func _on_RangeEnemy_animate_walk():
	play("idle")
