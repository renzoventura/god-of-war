extends Node2D

enum {IDLE, FLY, RETRIEVE, STICK}

export var first_load = false

export (float) var acceleration = 2 * 60
export (float) var fly_speed = 50 * 60
export (bool) var is_attacking = false
onready var animationPlayer = $"SwordArea/AnimationPlayer"
onready var parent: = get_parent()
onready var swordCollision = $"SwordArea/CollisionShape2D"

const recharge_mana_amount = 3
var enemy_scene = preload("res://scenes/enemy/Enemy.tscn")

var can_return: bool = true
var state: int = IDLE
var velocity: = Vector2.ZERO
var pos: = Vector2.ZERO
var speed:float
var is_returnable = false
var body_sticked_on;
var mana = 0


func _ready():
	
	get_tree().call_group("Enemy", "toggle_frozen", false)
	is_attacking = false
	if(first_load):
		mana = recharge_mana_amount
	if(get_tree().call_group("GUI", "get_is_charged")):
#		print("RECHARGING MANA")
		mana = recharge_mana_amount
	get_tree().call_group("GUI", "update_mana", mana)
	get_tree().call_group("GUI", "update_axe", true)
	idle_position()

func _physics_process(delta):
	match state:
		IDLE:
			idle()
		FLY:
			fly(delta)
		RETRIEVE:
			retrieve(delta)
		STICK:
			stick()

func attack():
		animationPlayer.play("Swing")
#		print(mana)

func idle():
	can_return = false
	if Input.is_action_just_pressed("attack"):
		attack()
	elif (Input.is_action_just_pressed("throw") and !is_attacking):
		flying()
		get_tree().call_group("GUI", "update_axe", false)
		swordCollision.disabled = false
		fly_speed = 20 * 60
		if(!is_returnable):
			 $ReturnTimer.start()
		get_tree().call_group("Player", "disable_axe_movement")
		$Timer.start()

func spin_axe(delta:float):
	rotation_degrees += 360*delta*7

func retrieve_position():
	if(Input.is_action_just_pressed("throw") and is_returnable):
		if(body_sticked_on != null):
			body_sticked_on.toggle_frozen(false)
			get_tree().call_group("Enemy", "toggle_frozen", false)
			get_tree().call_group("Player", "toggle_is_charged", true, recharge_mana_amount)
		else:
			get_tree().call_group("Player", "toggle_is_charged", false, mana)
		body_sticked_on = null
		state = RETRIEVE
		fly_speed = 4 * 60
		
func force_retrieve():
	if(body_sticked_on != null):
		get_tree().call_group("Enemy", "toggle_frozen", false)
		get_tree().call_group("Player", "toggle_is_charged", true, recharge_mana_amount)
	else:
		get_tree().call_group("Player", "toggle_is_charged", false, mana)
#	get_tree().call_group("Player", "toggle_is_charged", false, mana)
	state = RETRIEVE
	fly_speed = 4 * 60

func fly(delta:float):
	var trans = get_global_transform()
	var new_pos = trans.basis_xform(Vector2(0,0))
	velocity += (new_pos).normalized() * speed
	velocity = velocity.clamped(fly_speed)
	pos += velocity * delta 
	global_position = pos
	spin_axe(delta)
	retrieve_position()

func retrieve(delta:float):
	velocity += (get_target() - pos).normalized() * speed
	velocity = velocity.clamped(fly_speed)
	pos += velocity * delta
	global_position = pos
	spin_axe(delta)
	var dist = global_position.distance_to(get_target())

func flying():
	fly_speed = 4 * 60
	state = FLY
	velocity = (get_global_mouse_position() - global_position).normalized() * fly_speed
	speed = acceleration
	pos = global_position

func idle_position():
	state = IDLE

func stick():
	if (!weakref(body_sticked_on).get_ref() || body_sticked_on.name == "BossEnemy"):
		force_retrieve()
	else:
		global_position = body_sticked_on.global_position
		retrieve_position()

func get_target()->Vector2:
	var player = get_tree().get_root().find_node("Player", true, false)
	var player_direction = (player.global_position)
	return player_direction + Vector2(0,-2)

func _on_Timer_timeout():
	can_return = true

func _on_Area2D_body_entered(body):
#	print(body.name)
	if(body.name == "Player" and state == RETRIEVE and is_returnable):
		body.renew_axe()
		is_returnable = false
	#BIG WORK AROUND FOR INHERITED CLASSES
	elif (body.get_parent().name == "Enemies" and state == FLY):
#	elif (body) and state == FLY):
		body_sticked_on = body
		state = STICK
	elif (body.name == "TileMap" and state != RETRIEVE and state != IDLE):
		force_retrieve()

func _on_ReturnTimer_timeout():
	is_returnable = true

func is_flying()->bool:
	return state == FLY

func is_returning()->bool:
	return state == RETRIEVE
	
func is_idle()->bool:
	return state == IDLE
	
func is_sticking()->bool:
	return state == STICK

func init(is_charged, new_mana):
	mana = new_mana

func has_mana_damage():
	return mana > 0

func use_up_mana():
	if(state != STICK):
		mana -= 1
		get_tree().call_group("GUI", "update_mana", mana)
