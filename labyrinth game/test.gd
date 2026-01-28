extends Node
class_name test

@export var tilemap : TileMap
@export var camera: Camera2D

var maze_size = 10

func _input(event:InputEvent):
	if event.is_action_pressed("Down"):
		get_viewport().set_input_as_handled()
		return
	if event.is_action_pressed("Up"):
		get_viewport().set_input_as_handled()
		return

func _ready():
	make_and_set_maze()
	
func make_and_set_maze():
	print("test")
	##tilemap.clear()
	var maze3 = maze2.new(maze_size,maze_size)
	maze3.make_maze()
	for x in maze_size:
		for y in maze_size:
			var  point = Vector2i(x,y)
			if maze3.grid.get_from_point(point):
				print(Vector2i(x,y), maze3.grid.get_from_point(point))
				##tilemap.set_cell(0, point, 0, Vector2i(0,0))
	##camera.position = tilemap.map_to_local(tilemap.get_used_rect().get_center())
	print("Maze grid:")
	for y in range(maze_size):
		var row = ""
		for x in range(maze_size):
			row += str(maze3.grid.get_from_point(Vector2i(x, y))) + " "
		print(row)
