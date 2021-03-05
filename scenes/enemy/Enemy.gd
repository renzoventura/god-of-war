extends KinematicBody2D

enum {IDLE, FROZEN, ATTACK}
const sword_damage = 1

var motion = Vector2(0,0)
var isFrozen = false;
var state: int = IDLE
var health = 5

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

func idle():
	move()
	move_and_slide(motion)

func frozen():
	pass 
	
func move():
	motion.x = 10

func attack():
#	print("Attacking!")
	pass

func hit():
	health -= sword_damage
	if(health <= 0):
		queue_free()


	
	
func _on_EnemyHitbox_area_entered(area):
	if (area.name == "SwordArea"):
		if(area.get_parent().is_flying()):
			print("thrown hit")
		else: 
			print("close hit")
		print("HIT!");
		hit()

func toggle_frozen():
#	print("TOGGLED")
	isFrozen = !isFrozen;
	if(isFrozen):
		state = FROZEN
	else:
		state = IDLE

func _on_DectectionZone_body_entered(body):
	if(body.name == "Player"):
		print("Detect Player")
		state = ATTACK


func _on_DectectionZone_body_exited(body):
	if(body.name == "Player"):
		print("Detect LEAVING Player")
		state = IDLE
