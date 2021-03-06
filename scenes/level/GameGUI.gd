extends CanvasLayer

onready var livesContainer = $"Control/VBoxContainer/LivesAndAxeContainer/LivesContainer"
onready var axeContainer = $"Control/VBoxContainer/LivesAndAxeContainer/AxeContainer"
onready var mana_container = $"Control/VBoxContainer/ManaContainer"
onready var stamina_meter = $"Control/VBoxContainer/StaminaMeter"
var heart_pre_load = preload("res://scenes/level/Heart.tscn")
var mana_preload = preload("res://scenes/level/Mana.tscn")
var axe_preload  = preload("res://scenes/level/AxeTexture.tscn")

func hide_gui():
	$Control.visible = false
	
func show_gui():
	$Control.visible = true

func _ready():
	update_lives(5)
	update_mana(5)
	
func update_lives(lives):
	for child in livesContainer.get_children():
		child.queue_free()
	for i in range(lives):
		var lifeInstance = heart_pre_load.instance();
		lifeInstance.rect_scale = Vector2(5,5)
		print(lifeInstance.rect_scale)
		livesContainer.add_child(lifeInstance)

func update_mana(mana):
	for child in mana_container.get_children():
		child.queue_free()
	for i in range(mana):
		var manaInstance = mana_preload.instance();
		mana_container.add_child(manaInstance)
	
func update_axe(axe):
	print(axe)
	if(axe):
		var axeInstance = axe_preload.instance();
		axeContainer.add_child(axeInstance)
	else:
		for child in axeContainer.get_children():
			child.queue_free()

func update_stamina(value):
	stamina_meter.value = value
	
