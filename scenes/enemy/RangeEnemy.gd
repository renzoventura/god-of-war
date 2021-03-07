extends "res://scenes/enemy/Enemy.gd"

var bullet = preload("res://scenes/enemy/RangeBullet.tscn")
onready var bullet_container = $"Bullets"
onready var bullet_timer = $"BulletSpawner"
var canAttack : bool = false
var bullet_cooldown : bool = false
var charge_timer_lenght_list = [1,2,3,4]

func _ready():
	bullet_timer.wait_time = charge_timer_lenght_list[randi() % charge_timer_lenght_list.size()]
	bullet_timer.start()
	health = 2
	maxhealth = 2

func idle_feature():
	pass

func frozen_feature():
	pass
	
func attack_feature():
	if(canAttack):
		fireBullet()
		canAttack = false

func attack_mode_on():
	if(!canAttack):
		print(bullet_timer.wait_time)
		bullet_timer.start()

func fireBullet():
	var player = get_tree().get_root().find_node("Player", true, false)
	var player_direction = (player.global_position)
	var bullet_instance = bullet.instance()
	var dir = (player.global_position - global_position).normalized()
	bullet_instance.direction = dir
	bullet_timer.wait_time = charge_timer_lenght_list[randi() % charge_timer_lenght_list.size()]
	print(bullet_timer.wait_time)
	bullet_container.add_child(bullet_instance)
	bullet_timer.start()

func _on_BulletSpawner_timeout():
	canAttack = true
	bullet_cooldown = true
