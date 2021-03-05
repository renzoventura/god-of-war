extends Node2D

onready var animationPlayer = $"AnimationPlayer"

func _ready():
	pass # Replace with function body.

func attack():
	animationPlayer.play("Swing")
