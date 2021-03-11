extends Node2D

func _ready():
	pass
#	var image = preload("res://assets/player/cross_hair.png" )
#	Input.set_custom_mouse_cursor(image)
onready var gui = $"GUIs"

func add_boss_gui():
	var boss_health_preload = preload("res://scenes/level/BossGUI.tscn")
	var boss_health_instance = boss_health_preload.instance()
	gui.add_child(boss_health_instance)

func on_death():
	get_tree().reload_current_scene()
