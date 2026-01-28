extends CanvasLayer

func _ready() -> void:
	$Resume.pressed.connect(_unpause)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Pause"):
		if !Global.paused:
			_pause()
		else:
			_unpause()
func _pause():
	get_tree().paused = true
	$".".show()
	Global.paused = true

func _unpause():
	get_tree().paused = false
	$".".hide()
	Global.paused = false
