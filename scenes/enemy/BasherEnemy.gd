extends "res://scenes/enemy/Enemy.gd"

var player = null
export var SPEED:int = 30

onready var animationPlayer = $"AnimationPlayer"
onready var bashTimer = $"BashTimer"
onready var chargeTimer = $"ChargeTimer"

var is_bashing:bool = false
var is_done_charging: bool = false
var last_player_position; 

func attack_feature():
	if(!is_bashing):
		SPEED = 30
		chase_player()
	else:
		bash_attack()

func chase_player():
	player = get_tree().get_root().find_node("Player", true, false)
	var player_direction = player.position - self.position
	move_and_slide(SPEED * player_direction.normalized())

func bash_attack():
	SPEED = 300
	var player = get_tree().get_root().find_node("Player", true, false)
	var player_direction = last_player_position
	if(is_done_charging):
		print("DASH")
		move_and_slide(SPEED * player_direction.normalized())
	else:
		print("CHARGING")
	

func get_target()->Vector2:
	var player = get_tree().get_root().find_node("Player", true, false)
	var player_direction = (player.global_position)
	return player_direction + Vector2(0,-2)

func _on_AttackRange2_body_entered(body):
	if (state == ATTACK and !is_bashing):
		is_done_charging 
		player = get_tree().get_root().find_node("Player", true, false)
		last_player_position = player.position - self.position
		is_bashing = true
		chargeTimer.start()
		bashTimer.start()

func _on_AttackRange2_body_exited(body):
	pass # Replace with function body.

func _on_BashTimer_timeout():
	is_bashing = false
	is_done_charging = false

func _on_ChargeTimer_timeout():
	is_done_charging = true
