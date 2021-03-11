extends Area2D

onready var sprite = $Sprite
onready var collision = $"CollisionShape2D"
var opened_preload = preload("res://assets/level/gate_opened.png")
var closed_preload = preload("res://assets/level/gate_closed.png")

export var is_opened = false

func _ready():
	update_sprite()

func update_sprite():
	if (is_opened):
		open_gate()
	else:
		close_gate()
		
		
func open_gate():
	is_opened = true;
	sprite.set_texture(opened_preload)
	collision.disabled = false
	
func close_gate():
	is_opened = true;
	sprite.set_texture(closed_preload)
	collision.disabled = true
	


func _on_Enemies_open_gate():
	open_gate()
