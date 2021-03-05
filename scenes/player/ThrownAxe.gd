extends Node2D

enum {IDLE, FLY, STICK}
export (float) var acceleration = 0.1 * 60
export (float) var retrieve_speed = 3.5 * 60
export (float) var return_speed = 0.5 * 60
onready var parent: = get_parent()
var can_return: bool = true
var state: int = IDLE
var velocity: = Vector2.ZERO
var pos: = Vector2.ZERO
var speed:float

func _ready():
	idle_position()
	retrieve()

func _physics_process(delta):
	match state:
		IDLE:
			idle()
		FLY:
			fly(delta)
		STICK:
			stick()

func idle():
	look_at(get_global_mouse_position())
#	if Input.is_action_just_pressed("retrieve"):
#		retrieve()

func fly(delta:float):
	velocity += (get_target() - pos).normalized() * speed
	velocity = velocity.clamped(retrieve_speed)
	pos += velocity*delta #variable for disconnecting from parent movement
	global_position = pos
	rotation_degrees += 360*delta*4
	if can_return && pos.distance_to(get_target()) < 8:
		state = STICK

func stick():
	#place for your solution
	global_position = global_position.linear_interpolate(get_target(), 0.2)
	var dist = global_position.distance_to(get_target())
	if dist < 1:
		idle_position()

func retrieve():
	state = FLY
	can_return = false
	$Timer.start()
	velocity = (get_global_mouse_position() - global_position).normalized() * retrieve_speed
	speed = acceleration
	pos = global_position #variable for disconnecting from parent movement

func idle_position():
	state = IDLE
	global_position = get_target()

func get_target()->Vector2:
	var player = get_tree().get_root().find_node("Player", true, false)
	var player_direction = (player.global_position - global_position)
	return player_direction + Vector2(0,-2)
	

func _on_Timer_timeout():
	can_return = true
	speed = return_speed
