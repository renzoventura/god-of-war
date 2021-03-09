extends AudioStreamPlayer2D

var pitch_scales = [ 0.8, 0.9, 1.0, 1.1]
var bgMusic = "res://soundeffects/player/hit_enemy.wav"
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func hit_sound_effect():
	print("PLAYING")
	pitch_scale = pitch_scales[randi() % pitch_scales.size()]
	volume_db = -6
	print(pitch_scale)
	stream = load(bgMusic)
	play()
