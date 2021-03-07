extends "res://scenes/enemy/Enemy.gd"

var player = null
export var SPEED:int = 30
onready var weapons = $"Weapons"
var spin_value = 0

func _ready():
	health = 20
	maxhealth = 20
	pass # Replace with function body.

func attack_feature():
	chase_player()
	spin_orbs()

func chase_player():
	player = get_tree().get_root().find_node("Player", true, false)
	var player_direction = player.position - self.position
	move_and_slide(SPEED * player_direction.normalized())

func hurt():
	state_label.text = "HURT"
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
