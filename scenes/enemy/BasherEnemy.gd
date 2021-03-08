extends "res://scenes/enemy/Enemy.gd"

signal animate_bashing
signal animate_idle
signal animate_hurt

var BASH_SPEED = 120

onready var animationPlayer = $"AnimationPlayer"
onready var attackHitBoxShape = $"AttackHitBox/CollisionShape2D"
onready var canBashTimer = $"Cooldown"

onready var bashDurationTimer = $"BashDuration"
export var SPEED:int = 10
var list_of_speed = [100, 110, 120, 130, 140]
var last_player_position; 
var player = null

var can_bash = true
var is_bashing = false

func _ready():
	randomize()
	BASH_SPEED = list_of_speed[randi() % list_of_speed.size()]
#	BASH_SPEED = 150
	isntanced_position = global_position;
	healthText.text = generate_health_string()
	set_up_health_bar()
	
func attack_feature():
	bash_attack()

func chase_player():
	animate_idle()
	player = get_tree().get_root().find_node("Player", true, false)
	var player_direction = player.position - self.position
	move_and_slide(30 * player_direction.normalized())
	
func bash_attack():
	var player = get_tree().get_root().find_node("Player", true, false)
	var player_direction = last_player_position
	animate_bashing()
	move_and_slide(BASH_SPEED * player_direction.normalized())

func _on_AttackRange2_body_entered(body):
	if (state == ATTACK):
		player = get_tree().get_root().find_node("Player", true, false)
		last_player_position = player.position - self.position

func _on_AttackRange2_body_exited(body):
	pass # Replace with function body.

func _on_AttackHitBox_body_entered(body):
	player = get_tree().get_root().find_node("Player", true, false)
	if(body.name == "Player"):
		last_player_position = -player.position - self.position
	elif(body.name == "TileMap"):
		last_player_position = player.position - self.position
		
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

func _on_Cooldown_timeout():
	can_bash = true

func _on_BashDuration_timeout():
	is_bashing = false
