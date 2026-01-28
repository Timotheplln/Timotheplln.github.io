extends Camera2D

func _ready() -> void:
	zoom = Vector2i(3, 3)
	if !Global.separated_control:
		make_current()
