extends AudioStreamPlayer

func _ready() -> void:
	stream = load("res://maze-ambience-background.wav")
	play()

func _on_finished() -> void:
	if stream == load("res://maze-ambience-background.wav"):
		stream = load("res://maze-ambience-background2.wav")
		play()
	elif stream == load("res://maze-ambience-background2.wav"):
		stream = load("res://maze-ambience-background3.wav")
		play()
	elif stream == load("res://maze-ambience-background3.wav"):
		stream = load("res://maze-ambience-background.wav")
		play()
