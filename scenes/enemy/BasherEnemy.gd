extends "res://scenes/enemy/Enemy.gd"

var player = null
export var SPEED:int = 30
const BASH_SPEED = 200

var charge_timer_lenght_list = [0.5]

onready var animationPlayer = $"AnimationPlayer"
onready var bashTimer = $"BashTimer"
onready var chargeTimer = $"ChargeTimer"
onready var coolDownTimer = $"CoolDownTimer"
onready var attackHitBoxShape = $"AttackHitBox/CollisionShape2D"
var is_bashing:bool = false
var is_done_charging: bool = false
var last_player_position; 
var resting = false

signal animate_bashing
signal animate_idle
signal animate_hurt

func attack_feature():
	randomize()
#	if(true):
	if(!resting):
		if(!is_bashing):
			attackHitBoxShape.disabled = true
			SPEED = 30
			chase_player()
			animate_idle()
		else:
			attackHitBoxShape.disabled = false
			bash_attack()
	else:
		SPEED = 15
		animate_idle()
		chase_player()
		pass

func chase_player():
	player = get_tree().get_root().find_node("Player", true, false)
	var player_direction = player.position - self.position
	move_and_slide(SPEED * player_direction.normalized())
	

func bash_attack():
	SPEED = BASH_SPEED
	var player = get_tree().get_root().find_node("Player", true, false)
	var player_direction = last_player_position
	if(is_done_charging):
		chargeTimer.start()
		print("DONE CHARGING")
		animate_bashing()
		move_and_slide(SPEED * player_direction.normalized())
	else:
		print("CHARGING")
		animate_idle()

func get_target()->Vector2:
	var player = get_tree().get_root().find_node("Player", true, false)
	var player_direction = (player.global_position)
	return player_direction + Vector2(0,-2)

func _on_AttackRange2_body_entered(body):
	if (state == ATTACK and !is_bashing):
		is_done_charging = true
		player = get_tree().get_root().find_node("Player", true, false)
		last_player_position = player.position - self.position
		is_bashing = true
		chargeTimer.wait_time = charge_timer_lenght_list[randi() % charge_timer_lenght_list.size()]
		chargeTimer.start()
		bashTimer.start()

func _on_AttackRange2_body_exited(body):
	pass # Replace with function body.

func _on_BashTimer_timeout():
	is_bashing = false
	is_done_charging = false
	resting = false
	coolDownTimer.start()

func _on_ChargeTimer_timeout():
	is_done_charging = true

func _on_CoolDownTimer_timeout():
	resting = false
	is_bashing = true
	
func _on_AttackHitBox_body_entered(body):
	if(body.name == "Player"):
		resting = true
		coolDownTimer.start()
	elif(body.name == "TileMap"):
		is_bashing = false
		state = IDLE
		
func idle_feature():
	animate_idle()
	var player_node = get_tree().get_root().find_node("Player", true, false)
	if(detectionZone.overlaps_body(player_node) || detectionZone.overlaps_area(player_node)):
		state = ATTACK
	else:
		return_to_instanced_area()

func animate_idle():
	emit_signal("animate_idle")
	
func hurt():
	animate_hurt()
	state_label.text = "HURT"
	
func animate_hurt():
	emit_signal("animate_hurt")

func animate_bashing():
	emit_signal("animate_bashing")

