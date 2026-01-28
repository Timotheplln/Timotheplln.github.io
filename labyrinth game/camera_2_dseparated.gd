extends Camera2D

@export var speed := 300.0

func _ready() -> void:
	zoom = Vector2i(3, 3)
	if Global.separated_control:
		make_current()
		position = $"../TileMap".map_to_local(Vector2i(Global.maze_width/2, Global.maze_height/2))
	

func _process(delta):
	if Global.separated_control:
		var move = Vector2.ZERO

		if Input.is_action_pressed("Right_cam"):
			move.x += 1
		if Input.is_action_pressed("Left_cam"):
			move.x -= 1
		if Input.is_action_pressed("Down_cam"):
			move.y += 1
		if Input.is_action_pressed("Up_cam"):
			move.y -= 1

		position += move.normalized() * speed * delta
