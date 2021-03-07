extends "res://scenes/enemy/Enemy.gd"

var player = null
export var SPEED:int = 30
onready var weapons = $"Weapons"
onready var orbsRandomizer = $"OrbsRandomizer"
var spin_value = 0

var orb_spin_multiplier = 2
var orb_position_speed = 0.7
var value = 0.2
var moved_value = 0
var max_moved_value = 50
var max_negative_moved_value = -30

var orb_spin_multiplier_list = [1.5, 2, 2.5]

func _ready():
	orbsRandomizer.start()
	health = 100
	maxhealth = 100
	pass # Replace with function body.

func attack_feature():
	spin_orbs()
	move_orbs()

func hurt():
	state_label.text = "HURT"
	spin_orbs()
	move_orbs()

func frozen_feature():
	spin_orbs()

func spin_orbs():
	weapons.set_rotation_degrees(get_rotation()) 
	update_rotation(weapons.rotation_degrees)

var is_adding = false

func get_rotation():
	if(is_adding):
		return weapons.rotation_degrees - (PI/orb_spin_multiplier);
	else:
		return weapons.rotation_degrees + (PI/orb_spin_multiplier);
		
func update_rotation(value):
	if(value > 359): 
		weapons.rotation_degrees = 0

func move_orbs():
	moved_value += value
	print(moved_value)
	update_moved_value()
	for positions in weapons.get_children():
		if(positions.position.y > 0):
			positions.position.y += value
		elif(positions.position.y < 0):
			positions.position.y -= value
		if(positions.position.x > 0):
			positions.position.x += value
		elif(positions.position.x < 0):
			positions.position.x -= value
#		if(positions.name == "Position2D"):
#			print(positions.name + str(positions.position))
			
func update_moved_value():
	if(moved_value > max_moved_value):
		value = -orb_position_speed
	elif(moved_value < max_negative_moved_value):
		value = orb_position_speed

func spawn_rangers_1():
	print("Spawning rangers 1 ")
	
func spawn_rangers_2():
	print("Spawning rangers 2 ")

func spwan_bashers():
	print("spawning bashers")

func spawn_giants():
	print("spawning giants")


func _on_OrbsRandomizer_timeout():
	orb_spin_multiplier = orb_spin_multiplier_list[randi() % orb_spin_multiplier_list.size()]
	pass # Replace with function body.
