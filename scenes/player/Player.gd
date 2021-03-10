extends KinematicBody2D

enum {ATTACK, IDLE, DASH, HURT}

const FRICTION = 0.1
const DASH_COST : int = 30

var DASH_TIME= 0.1
var dash_acc : int = 0 
var max_stamina  : int= 100
var stamina : int = 100
var recharge_per_timer : int = 1
var lives  : int= 6
var max_lives : int = 6
var motion = Vector2(0,0)
var SPEED  : int = 100;
var MAX_SPEED  : int = 700;
var DASH_SPEED : int = 500;
var is_thrown = false
var state : int = IDLE
var isDashEnabled = true;

onready var sword_position = $"Center"
onready var sword_position_container = $"Center/offset/Node2D"
onready var sword = $"Center/offset/Node2D/Sword"
onready var player_hit_box = $"CollisionShape2D"
onready var dashTimer = $"DashTimer"
onready var staminaChargerTimer = $"StaminaChargerTimer"
onready var hurtTimer = $"HurtTimer"
onready var playerStateLabel = $"PlayerState"
onready var sprite = $"SpriteAnimation"
onready var camera = $Camera2D
onready var swingSfx = $"AudioStreamPlayer2D"
onready var powerup = $"PowerUp"
onready var impact = $"Impact"
onready var lowhealth = $"lowhealth"

var is_charged : bool = false
var axe_mana : int = 0
var is_invinsible : bool = false
var is_facing_right : bool = true
var shake_amount : int =  3
var pitch_scales = [0.9, 1.0, 1.2, 1.4]

signal animate_walk;
signal animate_dodge;
signal animate_hurt;

func _ready():
	update_lives_gui()
	staminaChargerTimer.start()

func _process(delta):
	lowhealth_effect()
	update_stamina_gui()
	match state:
		IDLE:
			idle()
		DASH:
			dashing(delta)
		HURT:
			hurting()

func hurting():
	playerStateLabel.text = "HURT"
	animate_hurt()
#	move()
#	move_sword()
#	move_and_slide(motion)
	
func idle():
	playerStateLabel.text = "IDLE"
	move()
#	animate_walk()
	move_sword()
	dash()
	move_and_slide(motion)
	
func updateSpeed():
	if(state == DASH):
		SPEED = DASH_SPEED;
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
		animate_walk()
		motion.y = clamp(motion.y - SPEED, -MAX_SPEED, 0)
	elif Input.is_action_pressed("down"):
		animate_walk()
		motion.y = clamp(motion.y + SPEED, 0, MAX_SPEED)
	else: 
		motion.y = lerp(motion.y, 0, FRICTION)
	if Input.is_action_pressed("left"):
		animate_walk()
		motion.x = clamp(motion.x - SPEED, -MAX_SPEED, 0)
		is_facing_right = false
	elif Input.is_action_pressed("right"):
		animate_walk()
		motion.x = clamp(motion.x + SPEED, 0, MAX_SPEED)
		is_facing_right = true
	else: 
		motion.x = lerp(motion.x, 0, FRICTION)

func dash():
	if(Input.is_action_just_pressed("dash") and isDashEnabled and has_stamina_for(DASH_COST)):
		dash_sound_effect()
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
	playerStateLabel.text = "DASH"
	move()
	dash_acc += delta
	SPEED = DASH_SPEED
	if dash_acc >= DASH_TIME:    
		state = IDLE
		toggle_hit_box()
		motion = Vector2(0, 0)
		dash_acc = 0
	move_and_slide(motion)
	animate_dash()
	

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
		if(is_charged):
			power_sound_effect()
		axeInstance.init(is_charged, axe_mana)
		is_charged = false
		sword_position_container.call_deferred("add_child",axeInstance)
		enable_axe_movement()

func toggle_hit_box():
	pass

func _on_DashTimer_timeout():
#	print("STOP DASH")
	state = IDLE
	isDashEnabled = true;

func _on_StaminaCharger_timeout():
	if(max_stamina > stamina):
		stamina += recharge_per_timer

func update_stamina_gui():
	get_tree().call_group("GUI", "update_stamina", stamina)
	
func update_lives_gui():
	get_tree().call_group("GUI", "update_lives", lives, max_lives)
	
func toggle_is_charged(value, mana):
	if(mana != null):
		axe_mana = mana
	is_charged = value;

func get_is_charged()->bool:
	return is_charged

func _on_HitBox_body_entered(body):
	if(!is_invinsible):
		is_invinsible = true
		damage()
		hurtTimer.start()
		state = HURT

func damage():
	if(lives >= 1):
		lives = lives - 1
		shake_camera()
		impact_sound_effect()
		update_lives_gui()
	
func _on_HurtTimer_timeout():
	state = IDLE
	is_invinsible = false

func _on_HitBox_area_entered(area):
	if(!is_invinsible):
		is_invinsible = true
		damage()
		hurtTimer.start()
		state = HURT

func animate_walk():
	emit_signal("animate_walk", motion, is_facing_right)

func animate_hurt():
	emit_signal("animate_hurt")

func animate_dash():
	emit_signal("animate_dodge")

func shake_camera():
	camera.set_offset(Vector2(rand_range(-1.0, 1.0) * shake_amount, rand_range(-1.0, 1.0) * shake_amount))
	
func dash_sound_effect():
	swingSfx.pitch_scale = pitch_scales[randi() % pitch_scales.size()] + 1
	swingSfx.play()

func power_sound_effect():
	powerup.pitch_scale = pitch_scales[randi() % pitch_scales.size()]
	powerup.play()

func impact_sound_effect():
	impact.pitch_scale = pitch_scales[randi() % pitch_scales.size()]
	impact.play()

var low_health_can_play = true
onready var lowhealth_timer = $"lowhealth/lowhealthTimer"

func lowhealth_effect():
	if(low_health_can_play):

		if(!lowhealth.playing and lives < 2 and lives != 0):
			low_health_can_play = false
			lowhealth_timer.start()
#			lowhealth.pitch_scale = pitch_scales[randi() % pitch_scales.size()] + 0.2
			lowhealth.play()



func _on_lowhealthTimer_timeout():
	low_health_can_play = true
