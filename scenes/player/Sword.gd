extends Node2D

enum {IDLE, FLY, RETRIEVE, STICK}



export (float) var acceleration = 2 * 60
export (float) var fly_speed = 50 * 60

onready var animationPlayer = $"SwordArea/AnimationPlayer"
onready var parent: = get_parent()
onready var swordCollision = $"SwordArea/CollisionShape2D"

const recharge_mana_amount = 5
var enemy_scene = preload("res://scenes/enemy/Enemy.tscn")

var can_return: bool = true
var state: int = IDLE
var velocity: = Vector2.ZERO
var pos: = Vector2.ZERO
var speed:float
var is_returnable = false
var body_sticked_on;
var mana = recharge_mana_amount

func _ready():
	mana = recharge_mana_amount
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
	if(mana > 0):
		animationPlayer.play("Swing")
		mana -= 1
#		print(mana)

	
func idle():
	can_return = false
	if Input.is_action_just_pressed("attack"):
		attack()
	if Input.is_action_just_pressed("throw"):
		flying()
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
			body_sticked_on.toggle_frozen()
		body_sticked_on = null
		state = RETRIEVE
		fly_speed = 4 * 60
		
func force_retrieve():
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
	if (!weakref(body_sticked_on).get_ref()):
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
	if(body.name == "Player" and state == RETRIEVE and is_returnable):
		body.renew_axe()
		is_returnable = false
	#BIG WORK AROUND FOR INHERITED CLASSES
	elif (body.get_parent().name == "Enemies" and state == FLY):
#	elif (body) and state == FLY):
		body_sticked_on = body
		body_sticked_on.toggle_frozen()
		state = STICK

func _on_ReturnTimer_timeout():
	is_returnable = true

func is_flying()->bool:
	return state == FLY
