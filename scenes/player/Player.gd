extends KinematicBody2D

var motion = Vector2(0,0)
var SPEED = 200;
var MAX_SPEED = 200;
const FRICTION = 0.1

onready var sword_position = $"Center"
onready var sword_position_container = $"Center/offset"
onready var sword = $"Center/offset/Sword"


var is_thrown = false

func _process(delta):
	move()
	move_sword()
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
#
func move_sword():
	if(!is_thrown):
		sword_position.look_at(get_global_mouse_position())
	else: 
		pass


func disable_axe_movement():
	is_thrown = true
	
func enable_axe_movement():
	is_thrown = false
	
func renew_axe():
	if(is_thrown):
		for n in sword_position_container.get_children():
			sword_position_container.remove_child(n)
			n.queue_free()
		var preloadAxe = preload("res://scenes/player/Sword.tscn")
		var axeInstance = preloadAxe;
		sword_position_container.add_child(axeInstance)
		print(str(sword_position_container.get_children().size()))
	
