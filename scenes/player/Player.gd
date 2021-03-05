extends KinematicBody2D

var motion = Vector2(0,0)
var motion_up = Vector2(0,-1)
var SPEED = 200;
var MAX_SPEED = 200;
const FRICTION = 0.1

onready var sword_position = $"Center"
onready var sword = $"Center/offset/Sword"

func _process(delta):
	move()
	move_sword()
	attack()
	move_and_slide(motion)

func move():
	if Input.is_action_pressed("up"):
		motion.y = clamp(motion.y - SPEED, -MAX_SPEED, 0)
	elif Input.is_action_pressed("down"):
		motion.y = clamp(motion.y + SPEED, 0, MAX_SPEED)
	else: 
		motion.y = lerp(motion.y, 0, FRICTION)
	if Input.is_action_pressed("left"):
		motion.x = clamp(motion.x - SPEED, -MAX_SPEED, 0)
	elif Input.is_action_pressed("right"):
		motion.x = clamp(motion.x + SPEED, 0, MAX_SPEED)
	else: 
		motion.x = lerp(motion.x, 0, FRICTION)

func move_sword():
	sword_position.look_at(get_global_mouse_position())
	
func attack():
	if (Input.is_action_just_pressed("attack")):
		sword.attack()
		
