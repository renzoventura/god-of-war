extends "res://scenes/enemy/Enemy.gd"

var player = null
export var SPEED:int = 30
const BASH_SPEED = 400

var charge_timer_lenght_list = [0.3, 0.5, 0.8, 1]

onready var animationPlayer = $"AnimationPlayer"
onready var bashTimer = $"BashTimer"
onready var chargeTimer = $"ChargeTimer"
onready var coolDownTimer = $"CoolDownTimer"
onready var attackHitBoxShape = $"AttackHitBox/CollisionShape2D"
var is_bashing:bool = false
var is_done_charging: bool = false
var last_player_position; 
var resting = false

func attack_feature():
	if(!resting):
		if(!is_bashing):
			attackHitBoxShape.disabled = true
			SPEED = 30
			chase_player()
		else:
			attackHitBoxShape.disabled = false
			bash_attack()
	else:
		SPEED = 10
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
#		print("DASH")
		move_and_slide(SPEED * player_direction.normalized())
	else:
#		print("CHARGING")
		pass

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
		chargeTimer.wait_time = charge_timer_lenght_list[randi() % charge_timer_lenght_list.size()]
		chargeTimer.start()
		bashTimer.start()

func _on_AttackRange2_body_exited(body):
	pass # Replace with function body.

func _on_BashTimer_timeout():
	is_bashing = false
	is_done_charging = false
	resting = true
	coolDownTimer.start()

func _on_ChargeTimer_timeout():
	is_done_charging = true

func _on_CoolDownTimer_timeout():
	resting = false

func _on_AttackHitBox_body_entered(body):
	if(body.name == "Player" ):
#		print("BASHER HIT PLAYER")
		resting = true
		coolDownTimer.start()
	elif(body.name == "TileMap"):
#		print("BASHER HIT ENVIRONMENT")
		is_bashing = false
		state = IDLE
