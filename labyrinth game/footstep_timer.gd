extends Timer

@onready var sound = $"../footstepPlayer"
var footstep_sounds: Array[AudioStream] = []

func _ready():
	for i in range(9):
		var footstep_sound = load("res://footstep sound/Random1" + (".wav" if i == 0 else " (" + str(i) + ").wav"))
		footstep_sounds.append(footstep_sound)
		
	timeout.connect(_on_footstep_timer_timeout)

func _on_footstep_timer_timeout():
	if not sound.playing:
		var rand_index = randi_range(0, footstep_sounds.size() - 1)
		sound.stream = footstep_sounds[rand_index]
		sound.play()
		if wait_time != 0.5:
			wait_time = 0.5
