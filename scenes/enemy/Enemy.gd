extends KinematicBody2D

enum {IDLE, FROZEN, ATTACK, HURT}
const swing_damage = 3
const thrown_damage = 1

onready var state_label = $State
onready var staggerTimer = $StaggerTime
onready var healthText = $HealthText
onready var detectionZone = $"AI/DectectionZone"
onready var healthbar = $"Position2D/HealthBar"
onready var sprite_base = $Sprite
onready var frozen_sound_effect = $"FrozenSoundEffect"

onready var hitSound = $HitSound
var pitch_scales = [0.9, 1.0, 1.2, 1.4]

var motion = Vector2(0,0)
var isFrozen = false;
var state: int = IDLE
var health = 10
var maxhealth = 10
var return_speed = 50
# Called when the node enters the scene tree for the first time.

var isntanced_position

func _ready():
	randomize()

	isntanced_position = global_position;
	healthText.text = generate_health_string()
	set_up_health_bar()

func generate_health_string():
	var text = str(health) + "/" + str(maxhealth)
	return text
	
	
func _process(delta):
	modulate_if_frozen()
#	healthText.text = generate_health_string()
	update_health_bar()
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
	var player_node = get_tree().get_root().find_node("Player", true, false)
	if(detectionZone.overlaps_body(player_node) || detectionZone.overlaps_area(player_node)):
		state = ATTACK
	else:
		return_to_instanced_area()

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
	if(state != FROZEN):
		if (area.name == "SwordArea" and state != HURT):
			if(area.get_parent().is_flying()):
				hit(thrown_damage)
				play_frozen_effect()
				toggle_frozen(true)
			elif(area.get_parent().is_returning()):
				HitSoundEffect.hit_sound_effect()
				hit(thrown_damage)
			elif(area.get_parent().is_idle()): 
				if (area.get_parent().has_mana_damage()):
					area.get_parent().use_up_mana()
					HitSoundEffect.hit_sound_effect()
					hit(swing_damage * 2)
				else:
					HitSoundEffect.hit_sound_effect()
					hit(swing_damage)
			else:
				HitSoundEffect.hit_sound_effect()
				hit(thrown_damage)
	

func toggle_frozen(value):
	if(value):
		isFrozen = value
		state = FROZEN
	else:
		isFrozen = value
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

func return_to_instanced_area():
#	print("RETURNING")
	var player_direction = isntanced_position - self.position
	move_and_slide(return_speed * player_direction.normalized())
	
func set_up_health_bar():
	healthbar.value = health
	healthbar.max_value = maxhealth

func update_health_bar():
	healthbar.value = health

func modulate_if_frozen():
	if(state == FROZEN):
		sprite_base.self_modulate = Color(0,2, 2)
	else:
		sprite_base.self_modulate = Color(1, 1, 1)


func play_frozen_effect():
	if(!frozen_sound_effect.playing):
		frozen_sound_effect.pitch_scale = pitch_scales[randi() % pitch_scales.size()]
		frozen_sound_effect.play()
