extends Node2D

onready var animationPlayer = $"Area2D/AnimationPlayer"
#onready var thrown_axe_container = 
#const thrown_axe = preload("res://scenes/player/ThrownAxe.gd")

var is_thrown = false;

func _ready():
	pass # Replace with function body.

func _process(delta):
	pass
	
func attack():
	animationPlayer.play("Swing")

func use_skill():
	pass
#	if(!is_thrown):
#		throw()
#	else:
#		retrieve()
		
func throw():
	pass
#	var GrabedInstance= MySmokeResource.instance()
	

#
#func retrieve():
#	pass
