extends "res://scenes/enemy/Enemy.gd"

signal animate_bashing
signal animate_idle
signal animate_hurt

const BASH_SPEED = 200

onready var animationPlayer = $"AnimationPlayer"
onready var attackHitBoxShape = $"AttackHitBox/CollisionShape2D"

export var SPEED:int = 30

var last_player_position; 
var player = null

func attack_feature():
	randomize()
	bash_attack()

func chase_player():
	player = get_tree().get_root().find_node("Player", true, false)
	var player_direction = player.position - self.position
	move_and_slide(SPEED * player_direction.normalized())
	
func bash_attack():
	SPEED = BASH_SPEED
	var player = get_tree().get_root().find_node("Player", true, false)
	var player_direction = last_player_position
	animate_bashing()
	move_and_slide(SPEED * player_direction.normalized())

func _on_AttackRange2_body_entered(body):
	if (state == ATTACK):
		player = get_tree().get_root().find_node("Player", true, false)
		last_player_position = player.position - self.position

func _on_AttackRange2_body_exited(body):
	pass # Replace with function body.

func _on_AttackHitBox_body_entered(body):
	if(body.name == "Player"):
		print("HIT PLAYER")
	elif(body.name == "TileMap"):
		print("HIT TILEMAP")
		player = get_tree().get_root().find_node("Player", true, false)
		last_player_position = player.position - self.position
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

