extends Node2D

enum {IDLE, FLY, STICK}

export (float) var acceleration = 0.1 * 60
export (float) var fly_speed = 8 * 60
export (float) var return_speed = 1 * 60

onready var animationPlayer = $"Area2D/AnimationPlayer"
onready var parent: = get_parent()

var can_return: bool = true
var state: int = IDLE
var velocity: = Vector2.ZERO
var pos: = Vector2.ZERO
var speed:float
var is_thrown = false;
var is_returnable = false

func _ready():
	idle_position()

func _physics_process(delta):
	match state:
		IDLE:
			idle()
		FLY:
			fly(delta)
		STICK:
			stick(delta)

func attack():
	animationPlayer.play("Swing")
	
func idle():
	can_return = false
	if Input.is_action_just_pressed("attack"):
		attack()
	if Input.is_action_just_pressed("throw"):
		retrieve()
		if(!is_returnable):
			 $ReturnTimer.start()
		get_tree().call_group("Player", "disable_axe_movement")
		$Timer.start()

func spin_axe(delta:float):
	rotation_degrees += 360*delta*7
	
func fly(delta:float):
	var trans = get_global_transform()
	var new_pos = trans.basis_xform(Vector2(0,0))
	velocity += (new_pos).normalized() * speed
	velocity = velocity.clamped(fly_speed)
	pos += velocity * delta 
	global_position = pos
	spin_axe(delta)
	if(Input.is_action_just_pressed("throw") and is_returnable):
		state = STICK

func stick(delta:float):
	velocity += (get_target() - pos).normalized() * speed
	velocity = velocity.clamped(fly_speed)
	pos += velocity * delta
	global_position = pos
	spin_axe(delta)
	var dist = global_position.distance_to(get_target())

func retrieve():
	fly_speed = 4 * 60
	state = FLY
	velocity = (get_global_mouse_position() - global_position).normalized() * fly_speed
	speed = acceleration
	pos = global_position

func idle_position():
	state = IDLE

func get_target()->Vector2:
	var player = get_tree().get_root().find_node("Player", true, false)
	var player_direction = (player.global_position)
	return player_direction + Vector2(0,-2)

func _on_Timer_timeout():
	can_return = true
	speed = return_speed

func _on_Area2D_body_entered(body):
	if(body.name == "Player" and state == STICK and is_returnable):
		body.renew_axe()
		is_returnable = false

func _on_ReturnTimer_timeout():
	is_returnable = true
