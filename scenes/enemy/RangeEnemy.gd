extends "res://scenes/enemy/Enemy.gd"

var bullet = preload("res://scenes/enemy/RangeBullet.tscn")
onready var bullet_container = $"Bullets"
onready var bullet_timer = $"BulletSpawner"
var canAttack : bool = false
var bullet_cooldown : bool = false
var charge_timer_lenght_list = [1,2,3,4]
onready var sprite = $"Sprite"

signal animate_hurt
signal animate_walk

var is_facing_right = false

onready var fire = $Fire

func _ready():
	randomize()
	health = 4
	maxhealth = 4
	isntanced_position = global_position;
	healthText.text = generate_health_string()
	set_up_health_bar()
	bullet_timer.wait_time = charge_timer_lenght_list[randi() % charge_timer_lenght_list.size()]
	bullet_timer.start()

func idle_feature():
	animate_idle()
	var player_node = get_tree().get_root().find_node("Player", true, false)
	if(detectionZone.overlaps_body(player_node) || detectionZone.overlaps_area(player_node)):
		state = ATTACK

func frozen_feature():
	pass
	
func attack_feature():
	animate_idle()
	update_color_if_cooldown()
	if(canAttack):
		fire_sound_effect()
		fireBullet()
		canAttack = false

func attack_mode_on():
	if(!canAttack):
#		print(bullet_timer.wait_time)
		bullet_timer.start()

func fireBullet():
	var player = get_tree().get_root().find_node("Player", true, false)
	var player_direction = (player.global_position)
	var bullet_instance = bullet.instance()
	var dir = (player.global_position - global_position).normalized()
	bullet_instance.direction = dir
#	print(bullet_timer.wait_time)
	bullet_container.add_child(bullet_instance)
	bullet_timer.start()
#	print("attacked")

func _on_BulletSpawner_timeout():
	bullet_timer.wait_time = charge_timer_lenght_list[randi() % charge_timer_lenght_list.size()]
	canAttack = true
	bullet_cooldown = true

func animate_idle():
	var player = get_tree().get_root().find_node("Player", true, false)
	var player_direction = player.position - self.position
	is_facing_right = player_direction.x > 0
	emit_signal("animate_walk", is_facing_right)

func animate_hurt():
	emit_signal("animate_hurt")
	
func update_color_if_cooldown():
#	print("canAttack: " + str(canAttack))
	if(canAttack):
#		print("can attack")
		sprite.modulate = Color(255, 75 ,75)
	else:
#		print("NOT attack")
		sprite.modulate = Color(1,1,1)

func fire_sound_effect():
	fire.pitch_scale = pitch_scales[randi() % pitch_scales.size()] + 0.3
	fire.play()

