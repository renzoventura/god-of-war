extends CanvasLayer

onready var livesContainer = $"Control/VBoxContainer/LivesAndAxeContainer/LivesContainer"
onready var axeContainer = $"Control/VBoxContainer/LivesAndAxeContainer/AxeContainer"
onready var mana_container = $"Control/VBoxContainer/ManaContainer"
onready var stamina_meter = $"Control/VBoxContainer/StaminaMeter"
var heart_pre_load = preload("res://scenes/level/Heart.tscn")
var empty_heart_pre_load = preload("res://scenes/level/EmptyHeart.tscn")

var empty_mana_preload = preload("res://scenes/level/EmptyMana.tscn")
var mana_preload = preload("res://scenes/level/Mana.tscn")
var axe_preload  = preload("res://scenes/level/AxeTexture.tscn")

func hide_gui():
	$Control.visible = false
	
func show_gui():
	$Control.visible = true

func _ready():
	pass
	
func update_lives(lives, max_lives):
	for child in livesContainer.get_children():
		child.queue_free()
	for i in range(lives):
		var lifeInstance = heart_pre_load.instance();
		lifeInstance.rect_scale = Vector2(5,5)
#		print(lifeInstance.rect_scale)
		livesContainer.add_child(lifeInstance)
	if(max_lives > lives):
		for i in range(max_lives - lives):
			var emptyLifeInstance = empty_heart_pre_load.instance();
			emptyLifeInstance.rect_scale = Vector2(5,5)
			livesContainer.add_child(emptyLifeInstance)

func update_mana(mana, max_mana):
	for child in mana_container.get_children():
		child.queue_free()
	for i in range(mana):
		var manaInstance = mana_preload.instance();
		mana_container.add_child(manaInstance)
	if(max_mana > mana):
		for i in range(max_mana - mana):
			var emptyManaInstance = empty_mana_preload.instance();
			emptyManaInstance.rect_scale = Vector2(5,5)
			mana_container.add_child(emptyManaInstance)
			
func update_axe(axe):
#	print(axe)
	if(axe):
		var axeInstance = axe_preload.instance();
		axeContainer.add_child(axeInstance)
	else:
		for child in axeContainer.get_children():
			child.queue_free()

func update_stamina(value):
	stamina_meter.value = value
	
