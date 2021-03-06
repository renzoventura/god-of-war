extends KinematicBody2D

enum {IDLE, FROZEN, ATTACK, HURT}
const swing_damage = 3
const thrown_damage = 1

onready var state_label = $State
onready var staggerTimer = $StaggerTime
onready var healthText = $HealthText

var motion = Vector2(0,0)
var isFrozen = false;
var state: int = IDLE
var health = 10
var maxhealth = 10
# Called when the node enters the scene tree for the first time.
func _ready():
	healthText.text = generate_health_string()

func generate_health_string():
	var text = str(health) + "/" + str(maxhealth)
	return text
	
	
func _process(delta):
	healthText.text = generate_health_string()
	match state:
		IDLE:
			idle()
		FROZEN:
			frozen()
		ATTACK:
			attack()
		HURT:
			hurt()

func idle():
	state_label.text = "IDLE"
	idle_feature()

func idle_feature():
#	move()
#	move_and_slide(motion)
	pass

func frozen():
	state_label.text = "FROZEN"
	frozen_feature() 
	
func frozen_feature():
	pass
	
func move():
	motion.x = 10

func attack():
	state_label.text = "ATTACK"
	attack_feature()
	
func attack_feature():
	pass

func hit(damage):
	if(state != FROZEN):
		state = HURT
		staggerTimer.start()
		health -= damage
	if(health <= 0):
		queue_free()


func _on_EnemyHitbox_area_entered(area):
	if (area.name == "SwordArea" and state != HURT):
		if(area.get_parent().is_flying()):
			hit(thrown_damage)
			toggle_frozen(true)
		elif(area.get_parent().is_returning()):
			hit(thrown_damage)
		else: 
			if (area.get_parent().has_mana_damage()):
				area.get_parent().use_up_mana()
				hit(swing_damage * 2)
			else:
				hit(swing_damage)
	

func toggle_frozen(value):
	isFrozen = value;
	if(isFrozen):
		state = FROZEN
	else:
		staggerTimer.start()
		state = IDLE

func _on_DectectionZone_body_entered(body):
	if(body.name == "Player" and state != FROZEN):
#		print("Detect Player")
		state = ATTACK
		attack_mode_on()
		
func attack_mode_on():
	pass

func _on_DectectionZone_body_exited(body):
	if(body.name == "Player" and state != FROZEN ):
#		print("Detect LEAVING Player")
		state = IDLE

func hurt():
	state_label.text = "HURT"
#	print("State is hurt")

func _on_StaggerTime_timeout():
	if(state != FROZEN):
		state = IDLE
