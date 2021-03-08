extends "res://scenes/enemy/Enemy.gd"

var player = null
export var SPEED:int = 30
onready var weapons = $"Weapons"
var spin_value = 0

signal animate_hurt
signal animate_walk

var is_facing_right = false

func _ready():
	health = 25
	maxhealth = 25
	isntanced_position = global_position;
	healthText.text = generate_health_string()
	set_up_health_bar()
	pass # Replace with function body.

func attack_feature():
	chase_player()
	spin_orbs()

func chase_player():
	animate_walk()
	player = get_tree().get_root().find_node("Player", true, false)
	var player_direction = player.position - self.position
#	print(player_direction)
	is_facing_right = player_direction.x > 0
	move_and_slide(SPEED * player_direction.normalized())

func hurt():
	state_label.text = "HURT"
	animate_hurt()
	spin_orbs()

func frozen_feature():
	spin_orbs()

func spin_orbs():
	weapons.set_rotation_degrees(get_rotation()) 
	update_rotation(weapons.rotation_degrees)

var is_adding = false

func get_rotation():
	if(is_adding):
		return weapons.rotation_degrees - PI/2;
	else:
		return weapons.rotation_degrees + PI/2
		
func update_rotation(value):
	if(value > 359): 
		weapons.rotation_degrees = 0

func animate_walk():
	emit_signal("animate_walk", is_facing_right)
	
func animate_hurt():
	emit_signal("animate_hurt")
	
func return_to_instanced_area():
#	print("RETURNING")
	var player_direction = isntanced_position - self.position
	if(round(player_direction.x) != 0):
		is_facing_right = round(player_direction.x) >= 1
		emit_signal("animate_walk", is_facing_right)
		move_and_slide(return_speed * player_direction.normalized())

