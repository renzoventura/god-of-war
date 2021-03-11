extends Node2D
#
#enum {IDLE, FROZEN}
#var motion = Vector2(0,0)
#var isFrozen = false;
#var state: int = IDLE
## Called when the node enters the scene tree for the first time.
#func _ready():
#	pass # Replace with function body.
#
#
#
#func _process(delta):
#	match state:
#		IDLE:
#			idle()
#		FROZEN:
#			frozen()
#
#func idle():
#	move()
#	move_and_slide(motion)
#
#func frozen():
#	pass 
#
#func move():
#	motion.x = 10
#
#func _on_EnemyHitbox_area_entered(body):
##	print(body.name)
#	pass # Replace with function body.
#
#func _on_Area2D_area_entered(area):
#	if (area.name == "SwordArea"):
##		print("HIT!");
#		pass
#
#func toggle_frozen():
##	print("TOGGLED")
#	isFrozen = !isFrozen;
#	if(isFrozen):
#		state = FROZEN
#	else:
#		state = IDLE

