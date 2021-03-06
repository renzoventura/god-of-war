extends KinematicBody2D

enum {IDLE, FROZEN, ATTACK, HURT}
const swing_damage = 3
const thrown_damage = 1

onready var state_label = $State
onready var staggerTimer = $StaggerTime

var motion = Vector2(0,0)
var isFrozen = false;
var state: int = IDLE
var health = 10

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
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
#	move()
#	move_and_slide(motion)
	pass

func frozen():
	state_label.text = "FROZEN"
	pass 
	
func move():
	motion.x = 10

func attack():
	state_label.text = "ATTACK"
	pass

func hit(damage):
	state = HURT
	staggerTimer.start()
	health -= damage
	if(health <= 0):
		queue_free()


func _on_EnemyHitbox_area_entered(area):
	if (area.name == "SwordArea" and state != HURT):
		if(area.get_parent().is_flying()):
			hit(thrown_damage)
		else: 
			hit(swing_damage)

func toggle_frozen():
#	print("TOGGLED")
	isFrozen = !isFrozen;
	if(isFrozen):
		state = FROZEN
	else:
		state = IDLE

func _on_DectectionZone_body_entered(body):
	if(body.name == "Player" and state != FROZEN):
#		print("Detect Player")
		state = ATTACK

func _on_DectectionZone_body_exited(body):
	if(body.name == "Player" and state != FROZEN ):
#		print("Detect LEAVING Player")
		state = IDLE

func hurt():
	state_label.text = "HURT"
#	print("State is hurt")

func _on_StaggerTime_timeout():
	state = IDLE
