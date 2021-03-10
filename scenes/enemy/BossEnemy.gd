extends "res://scenes/enemy/Enemy.gd"

var player = null
export var SPEED:int = 30
onready var weapons = $"Weapons"
onready var orbsRandomizer = $"OrbsRandomizer"
onready var sprite = $"Sprite"
onready var orb_sound = $orb

var spin_value = 0
var orb_spin_multiplier = 2
var orb_position_speed = 0.4
var value = orb_position_speed
var moved_value = 0
var max_moved_value = 25
var max_negative_moved_value = -30
var orb_spin_multiplier_list = [1.5, 2, 2.5]
var orb_position_speed_list = [0.4, 0.7, 1]
var max_moved_value_list = [30, 50, 80] 
var max_negative_moved_value_list = [-30, 0] 
var is_facing_right = false
var color_damage = 1.3

signal animate_idle

func _ready():
	randomize()
	get_tree().call_group("Level", "add_boss_gui")
	health = 150
	maxhealth = 150
	isntanced_position = global_position;
	healthText.text = generate_health_string()
	set_up_health_bar()
	orbsRandomizer.start()
	pass # Replace with function body.

func attack_feature():
	spin_orbs()
	move_orbs()
	chase_player()
	sprite.modulate = Color(1,1,1)

func hurt():
	state_label.text = "HURT"
	spin_orbs()
	move_orbs()
	chase_player()
	sprite.modulate = Color(color_damage,color_damage,color_damage)
	
	
func frozen_feature():
	state = ATTACK
	spin_orbs()
	move_orbs()
	chase_player()
	
	sprite.modulate = Color(color_damage,color_damage,color_damage)
	sprite.modulate = Color(1,1,1)
func spin_orbs():
	play_orbs_sound()
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
#	print(moved_value)
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

func animate_idle():
	emit_signal("animate_idle", is_facing_right)
	
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
	orb_position_speed = orb_position_speed_list[randi() % orb_position_speed_list.size()]
	max_moved_value = max_moved_value_list[randi() % max_moved_value_list.size()]
#	max_negative_moved_value = max_negative_moved_value_list[randi() % max_negative_moved_value_list.size()]
	pass # Replace with function body.

func chase_player():
	player = get_tree().get_root().find_node("Player", true, false)
	var player_direction = player.position - self.position
#	print(player_direction)
	is_facing_right = player_direction.x > 0
	animate_idle()

func update_boss_health():
	get_tree().call_group("BossGUI", "update_health", health, maxhealth)

func update_health_bar():
	healthbar.value = health
	update_boss_health()
	
var orb_pitch_scales = [0.9, 1.0, 1.2, 1.4, 1.6, 1.8, 2]
func play_orbs_sound():
	if(!orb_sound.playing):
		orb_sound.pitch_scale = orb_pitch_scales[randi() % orb_pitch_scales.size()]
		orb_sound.play()

func hit(damage):
	if(state != FROZEN):
		state = HURT
		staggerTimer.start()
		update_boss_health()
		health -= damage
	if(health <= 0):
		update_boss_health()
		queue_free()

func play_frozen_effect():
	pass
