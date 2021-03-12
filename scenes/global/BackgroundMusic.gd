extends AudioStreamPlayer


const boss_music = "res://soundeffects/global/boss.wav"
const tutorial_music = "res://soundeffects/global/tutorial.wav"
const battle_music = "res://soundeffects/global/main_battle.wav"
const sad_music = "res://soundeffects/global/sad.wav"
const mysterious_music = "res://soundeffects/global/mysterious.wav"
const win_music = "res://soundeffects/global/win.wav"
const finished_music = "res://soundeffects/global/finished.wav"

func _ready():
	self.set_pause_mode(2) # Set pause mode to Process
	set_process(true)

func play_boss_music():
	volume_db = -10
	stream = load(boss_music)
	play()

func play_tutorial_music():
	volume_db = -22
	stream = load(tutorial_music)
	play()

func play_battle_music():
	volume_db = -15
	stream = load(battle_music)
	play()

func play_sad_music():
	volume_db = -20
	stream = load(sad_music)
	play()

func play_mysterious():
	volume_db = -20
	stream = load(mysterious_music)
	play()

func play_win():
	volume_db = -20
	stream = load(mysterious_music)
	play()

func play_finished():
	volume_db = -20
	stream = load(finished_music)
	play()
