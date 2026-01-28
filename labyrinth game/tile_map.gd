extends Node

@export var width: int = 20
@export var height: int = 20

func generate(tile_map: TileMap):
	var visited : Array[Vector2i]
	var search_stack : Array[Vector2i]
	var connections = {}
	var all_points = []
	
	for i in range(width * height):
		var x = i % width
		var y = floor(i / width)
		var point = Vector2i(x, y)
		all_points.append(point)
		connections[point] = 0b0000
	
	# Bordures extérieures (comme dans ton code original)
	for i in range(height):
		tile_map.set_cell(0, Vector2i(-1, i), 2, Vector2i(0, 0))
		tile_map.set_cell(0, Vector2i(width, i), 2, Vector2i(0, 0))
	for i in range(width):
		tile_map.set_cell(0, Vector2i(i, -1), 2, Vector2i(0, 0))
		tile_map.set_cell(0, Vector2i(i, height), 2, Vector2i(0, 0))
	tile_map.set_cell(0, Vector2i(-1, -1), 2, Vector2i(0, 0))
	tile_map.set_cell(0, Vector2i(width, -1), 2, Vector2i(0, 0))
	tile_map.set_cell(0, Vector2i(-1, height), 2, Vector2i(0, 0))
	tile_map.set_cell(0, Vector2i(width, height), 2, Vector2i(0, 0))
	
	var card_directions = [Vector2i.UP, Vector2i.DOWN, Vector2i.LEFT, Vector2i.RIGHT]
	var start = Vector2i(randi_range(1, width - 2), randi_range(1, height - 2))
	search_stack = [start]
	visited = [start]
	
	while search_stack.size() > 0:
		var current = search_stack.back()
		card_directions.shuffle()
		var added = false
		
		for dir in card_directions:
			var next = current + dir
			if next.x <= 0 or next.x >= width - 1 or next.y <= 0 or next.y >= height - 1:
				continue
			if visited.has(next):
				continue
			
			# Vérifie qu'on n'a pas de voisins proches déjà visités (comme dans maze2)
			var orth = Vector2i(dir.y, dir.x)
			var add_next = true
			for neighbor in [
				next + orth,
				next + orth + dir,
				next + dir,
				next - orth + dir,
				next - orth
			]:
				if neighbor.x < 0 or neighbor.x >= width or neighbor.y < 0 or neighbor.y >= height:
					continue
				if visited.has(neighbor):
					add_next = false
					break
			
			if add_next:
				# Mise à jour des connexions
				var cur_conns = connections[current]
				var next_conns = connections[next]
				connections[current] = _set_connection(cur_conns, next - current)
				connections[next] = _set_connection(next_conns, current - next)
				
				visited.push_back(next)
				search_stack.push_back(next)
				added = true
				break  # on passe au prochain current
		
		if not added:
			search_stack.pop_back()
	
	# Placement des tuiles dans la TileMap
	for point in all_points:
		var conns = connections[point]
		tile_map.set_cell(0, point, 2, Vector2i(int(conns), 0))
		
func _set_connection(connection_bits, target):
	match target:
	# 1 = connection
	# 0 = no connection
	#   NSEW
	# 0b1111
	#
	# Check which direction we're connecting and set the corresponding bit
		Vector2i(0, -1):
			return connection_bits | 0b1000
		Vector2i(0, 1):
			return connection_bits | 0b0100
		Vector2i(1, 0):
			return connection_bits | 0b0010
		Vector2i(-1, 0):
			return connection_bits | 0b0001

func _ready() -> void:
	var tile_map = $TileMap
	generate(tile_map)
	
