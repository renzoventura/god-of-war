extends CanvasLayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var boss_life_meter = $"Control/VBoxContainer/HBoxContainer/TextureProgress"
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func update_health(health, maxhealth):
	boss_life_meter.value = health
	boss_life_meter.max_value = maxhealth
	if(health <= 0):
		boss_life_meter.visible = false
