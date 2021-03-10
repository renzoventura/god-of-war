extends "res://scenes/enemy/Enemy.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
signal animate_idle
onready var sprite = $Sprite
var color_damage = 1.3
var SPEED = 20
var list_of_speed = [80, 100,120]
var is_facing_right = false

func _ready():
	randomize()
	health = 100
	maxhealth = 100
	SPEED = list_of_speed[randi() % list_of_speed.size()]
	isntanced_position = global_position;
	healthText.text = generate_health_string()
	set_up_health_bar()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func animate():
	emit_signal("animate_idle", is_facing_right)

func hurt():
	sprite.modulate = Color(color_damage,color_damage,color_damage)

func idle_feature():
	animate()
	sprite.modulate = Color(1,1,1)
	move_randomly()
	
func attack_feature():
	animate()
	move_randomly()
	
func move_randomly():
	chase_player()
	motion.y = SPEED
	move_and_slide(motion)

func _on_Timer_timeout():
	SPEED = -SPEED
	pass # Replace with function body.


var is_up = false
func _on_EnemyHitbox_body_entered(body):
#	print(body.name)
	if(body.name == "TileMap"):
		is_up = !is_up
#		print("SPEED: " + str(SPEED))
		var new_speed = list_of_speed[randi() % list_of_speed.size()]
		if(is_up):
			SPEED = -new_speed
		else:
			SPEED = new_speed 
		
#		print(" NEW SPEED: " + str(SPEED))

func chase_player():
	var player = get_tree().get_root().find_node("Player", true, false)
	var player_direction = player.position - self.position
	is_facing_right = player_direction.x > 0
	
	
