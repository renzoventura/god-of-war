extends KinematicBody2D

enum {ATTACK, IDLE, DASH, HURT}

const FRICTION = 0.1
const DASH_COST = 2

var DASH_TIME = 0.1
var dash_acc = 0 
var motion = Vector2(0,0)
var SPEED = 100;
var MAX_SPEED = 120;
var DASH_SPEED = 500;
var is_thrown = false
var state: int = IDLE
var isDashEnabled = true;

onready var sword_position = $"Center"
onready var sword_position_container = $"Center/offset/Node2D"
onready var sword = $"Center/offset/Node2D/Sword"
onready var player_hit_box = $"CollisionShape2D"
onready var dashTimer = $"DashTimer"
onready var staminaChargerTimer = $"StaminaChargerTimer"

var stamina = 5

func _ready():
	staminaChargerTimer.start()

func _process(delta):
	match state:
		IDLE:
			idle()
		DASH:
			dashing(delta)
		HURT:
			pass

func idle():
	move()
	move_sword()
	dash()
	move_and_slide(motion)
	
func updateSpeed():
	if(state == DASH):
		SPEED = 500;
		MAX_SPEED = SPEED;
	else:
		if(is_thrown):
			SPEED = 150;
			MAX_SPEED = SPEED;
		else: 
			SPEED = 100;
			MAX_SPEED = SPEED;
			
func move():
	updateSpeed()
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

func dash():
	if(Input.is_action_just_pressed("dash") and isDashEnabled and has_stamina_for(DASH_COST)):
		stamina -= DASH_COST
		toggle_hit_box()
		isDashEnabled = false
		dashTimer.start()
		state = DASH

func has_stamina_for(cost) -> bool:
	if stamina > cost:
#		print("Has stamina")
		return true;
	else: 
#		print("NO stamina")
		return false
		
func dashing(delta):
	move()
	dash_acc += delta
	SPEED = 500
	if dash_acc >= DASH_TIME:    
		state = IDLE
		toggle_hit_box()
		motion = Vector2(0, 0)
		dash_acc = 0
	move_and_slide(motion)

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
			n.queue_free()
		var preloadAxe = preload("res://scenes/player/Sword.tscn")
		var axeInstance = preloadAxe.instance();
		sword_position_container.call_deferred("add_child",axeInstance)
		enable_axe_movement()

func toggle_hit_box():
	player_hit_box.disabled = !player_hit_box.disabled

func _on_DashTimer_timeout():
	isDashEnabled = true;

func _on_StaminaCharger_timeout():
#	print("recharging")
	stamina += 1
