extends Node

@onready var agent = $ghost/NavigationAgent2D
@onready var buddy = $buddy
@onready var tile_map = $TileMap
@onready var ghost = $ghost
@onready var size_key = "%dx%d" % [Global.maze_width, Global.maze_height]

var width: int = Global.maze_width
var height: int = Global.maze_height
var ghost_pos
var safe_zone := []
var visited: Array = []
var search_stack: Array = []
var elapsed_time: float = 0



func generate():
	var player = $buddy
	var goal = $Container
	visited.clear()
	search_stack.clear()
	var connections = {}
	var dead_ends : Array = []
	var all_points = []
	
	for i in range(width * height):
		var x = i % width
		var y = floor(float(i) / float(width))
		var point = Vector2i(x, y)
		
		connections[point] = 0b0000  
		all_points.push_back(point)
		
	var start
	if Global.move:
		if Global.buddy:
			start = tile_map.local_to_map(ghost.position)
		else:
			start = tile_map.local_to_map(player.position)
	else:
		start = all_points[randi() % all_points.size()]
	search_stack = [start]
	visited = [start]
	player.position = tile_map.map_to_local(start)
	ghost_pos = tile_map.map_to_local(start)
	if Global.buddy:
		$ghost.position = tile_map.map_to_local(start)
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
	
	var farthest_point = start
	var max_distance = -1
	var min_goal_distance = int((width + height) / 8)
	
	for i in all_points:
		if Global.invis:
			tile_map.set_cell(1, i, 0, Vector2i(0, 0))
		if Global.anno_un:
			tile_map.set_cell(2, i, 0, Vector2i(1, 0))
	
	
	while search_stack.size() > 0: 
		var current = search_stack[0]
		var valid_neighbors = _get_valid_neighbors(current)
		var unvisited_neighbors: Array[Vector2i] = []
		for neighbor in valid_neighbors:
			if not visited.has(neighbor):
				unvisited_neighbors.push_front(neighbor)
		
		if unvisited_neighbors.size() > 0:
			var next = unvisited_neighbors[randi() % unvisited_neighbors.size()]
			
			var current_connections = connections[current]
			connections[current] = _set_connection(current_connections, next - current)

			var next_connections = connections[next]
			connections[next] = _set_connection(next_connections, current - next)

			visited.push_front(next)
			search_stack.push_front(next)
		else:
			search_stack.pop_front()
	var key_parts_positions = generate_random_positions()
	for i in range(5):
		var area = get_node_or_null("Area2D" + ("" if i == 0 else str(i + 1)))
		if area == null:
			push_warning("Zone de clé manquante : " + ("Area2D" + ("" if i == 0 else str(i + 1))))
			continue
		if !Global.key:
			area.hide()
		else:
			area.position = tile_map.map_to_local(key_parts_positions[i])
	for point in all_points:
		var conns = connections[point]
		#if !safe_zone.has(point):
		tile_map.set_cell(0, point, 2, Vector2i(int(conns), 0)) 
		
		var conn_count = 0
		for i in range(4):
			if (conns >> i) & 1:
				conn_count += 1
		if conn_count == 1:
			dead_ends.append(point)
			
	var candidate_dead_ends = dead_ends.filter(func(p):
		return p != start and p.distance_to(start) >= min_goal_distance
	)

	for point in candidate_dead_ends:
		var dist = point.distance_to(start)
		if dist > max_distance:
			max_distance = dist
			farthest_point = point
	
	if !Global.move and !tile_map.map_to_local(farthest_point) == tile_map.map_to_local(start):
		goal.position = tile_map.map_to_local(farthest_point)


func _get_valid_neighbors(tile: Vector2i) -> Array:
	var candidates = [
		tile + Vector2i(0, -1),
		tile + Vector2i(0, 1),
		tile + Vector2i(1, 0),
		tile + Vector2i(-1, 0)
	]
	var neighbors = []
	
	for candidate in candidates:
		if (candidate.x < 0
			or candidate.x >= width
			or candidate.y < 0
			or candidate.y >= height):
			continue
		
		neighbors.push_back(candidate)
	return neighbors
	
	
	
func _set_connection(connection_bits, target):
	match target:
		
		Vector2i(0, -1):
			return connection_bits | 0b1000
		Vector2i(0, 1):
			return connection_bits | 0b0100
		Vector2i(1, 0):
			return connection_bits | 0b0010
		Vector2i(-1, 0):
			return connection_bits | 0b0001
	
	
	
func _ready() -> void:
	Global.load_game()
	if Global.inverted:
		Global.challenge = "inverted"
	elif Global.anno_un:
		Global.challenge = "anno_un"
	elif Global.moving:
		Global.challenge = "moving"
	elif Global.invis:
		Global.challenge = "invisible"
	elif Global.ghost:
		Global.challenge = "ghost"
		ghost.can_move = true
		get_tree().paused = false
		Global.paused = false
	elif Global.buddy:
		Global.challenge = "buddy"
		ghost.can_move = true
		get_tree().paused = false
		Global.paused = false
		set_process(true)
		set_physics_process(true)
	elif Global.key:
		Global.challenge = "key"
	elif Global.separated_control:
		Global.challenge = "camera"
	else:
		Global.challenge = "none"
	if Global.best[Global.challenge].has(size_key):
		var besttime = Global.best[Global.challenge][size_key]
		var total_seconds := int(besttime/10)
		var minutes = total_seconds / 60
		var seconds = total_seconds % 60
		var tenths = int((besttime/10 - total_seconds) * 10)
		$UI/besttime.text = "%02d:%02d.%d" % [minutes, seconds, tenths]
	else:
		$UI/besttime.text = "99:99.9"
	generate()
	$UI/ColorRect.hide()
	$UI/VictoryLabel.hide()
	$UI/retry.hide()
	$UI/FinalTime.hide()
	$"UI/Menu?".hide()
	$Pause_menu.hide()
	$Settings_menu.hide()
	$Game_Over.hide()
	if Global.key == false:
		$Container/door.hide()
		$Container/door/lock.disabled = true
		$UI/key_sprites.hide()
	else:
		Global.key_found = false
		$Container/door.show()
		$Container/door/lock.disabled = false
		$UI/key_sprites/Key.show()
	$UI/retry.disabled = true
	$"UI/Menu?".pressed.connect(_on_menu_pressed)
	$"Pause_menu/Menu".pressed.connect(_on_menu_pressed)
	$Game_Over/Menu.pressed.connect(_on_menu_pressed)
	if Global.moving:
		$MovingMazeTimer.start()
		$MovingMazeTimer.timeout.connect(_on_MovingMazeTimer_timeout)
	$GameTimer.wait_time = 0.1
	$GameTimer.start()
	$GameTimer.connect("timeout", Callable(self, "_on_GameTimer_timeout"))
	$UI/timerlabel.text = "00:00.0"
	
		
		
func _trigger_victory():
	var bouton = $UI/retry
	var rainbow := 0.0
	
	$buddy.can_move = false
	$ghost.can_move = false
	$GameTimer.stop()
	bouton.disabled = false
	$UI/FinalTime.show()
	$UI/timerlabel.hide()
	$UI/besttime.hide()
	$UI/VictoryLabel.show()
	$UI/ColorRect.show()
	$"UI/Menu?".show()
	$Container/goal/AudioStreamPlayer.stream = load("res://win sound/victory sound.wav")
	$Container/goal/AudioStreamPlayer.play()
	get_tree().paused = true
	Global.paused = true
	bouton.show()
	_on_RainbowTimer_timeout(rainbow)
	
	if !Global.best[Global.challenge].has(size_key):
		Global.best[Global.challenge][size_key] = elapsed_time
		$UI/FinalTime.label_settings.font_color = Color(1, 0.84, 0)
		$UI/FinalTime.label_settings.outline_color = Color(0, 0, 0)
		Global.save_game()
	elif float(Global.best[Global.challenge][size_key])>elapsed_time:
		print(Global.best[Global.challenge][size_key])
		Global.best[Global.challenge][size_key] = elapsed_time
		$UI/FinalTime.label_settings.font_color = Color(1, 0.84, 0)
		$UI/FinalTime.label_settings.outline_color = Color(0, 0, 0)
		Global.save_game()
	else:
		$UI/FinalTime.label_settings.font_color = Color(0, 0, 0)
		$UI/FinalTime.label_settings.outline_color = Color(1, 1, 1)
		


func _on_RainbowTimer_timeout(rainbow_hue):
	rainbow_hue += 0.01
	if rainbow_hue > 1.0:
		rainbow_hue = 0.0
	var color = Color.from_hsv(rainbow_hue, 1.0, 1.0)
	$UI/VictoryLabel.modulate = color
	await get_tree().create_timer(0.02).timeout
	_on_RainbowTimer_timeout(rainbow_hue)
	
	
	
	
func _on_retry_pressed():
	if Global.paused:
		ghost.can_move = true
		get_tree().paused = false
		Global.paused = false
		Global.ded = false
		Global.move = false
	get_tree().reload_current_scene()
	
	
	
func _on_GameTimer_timeout():
	elapsed_time += 1
	var total_seconds := int(elapsed_time/10)
	var minutes = total_seconds / 60
	var seconds = total_seconds % 60
	var tenths = int((elapsed_time/10 - total_seconds) * 10)
	$UI/timerlabel.text = "%02d:%02d.%d" % [minutes, seconds, tenths]
	$UI/FinalTime.text = "%02d:%02d.%d" % [minutes, seconds, tenths]
	



func _on_menu_pressed():
	if Global.paused:
		get_tree().paused = false
	get_tree().change_scene_to_file("res://menu.tscn")
	
	
	
func _process(_delta: float):
	var cell_position = $TileMap.local_to_map($buddy.position)
	$TileMap.erase_cell(2, cell_position)
	$Pause_menu/hint.button_pressed = Global.hint
	if Global.hint:
		$buddy/arrow.show()
	else:
		$buddy/arrow.hide()
	if Global.key_found:
		for i in range(5):
			var key_part = get_node("UI/key_sprites/Key_frag" + (str(i + 1)))
			key_part.hide()
		$UI/key_sprites/Key2.show()
		$Container/door/door.texture = load("res://opened_door.png")
		$Container/door/lock.disabled = true
		


func _tp_ghost():
	$ghost.position = ghost_pos



func generate_random_positions() -> Array:
	var positions = []
	var min_index = int((width + height) / 2)
	var max_index = int((width * height) - min_index)
	var used_indices = {}

	while positions.size() < 5:
		var index = randi_range(min_index, max_index)
		var x = index % width
		var y = index / width
		var pos = Vector2(x, y)

		if not used_indices.has(index):
			positions.append(pos)
			used_indices[index] = true

	return positions



func _on_check_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		Global.hint = true
	else:
		Global.hint = false
	Global.save_game()
		
		
		
func _on_game_over():
	$Game_Over.show()
	get_tree().paused = true
	Global.paused = true
	$buddy/death.stream = load("res://ded sound/Random6.wav")
	$buddy/death.play()



func _on_MovingMazeTimer_timeout():
	safe_zone.clear()
	var positions_to_protect : Array
	Global.move = true  
	
	if !Global.buddy and !Global.ghost:
		positions_to_protect = [
			tile_map.local_to_map($buddy.position),
			tile_map.local_to_map($ghost.position),
			tile_map.local_to_map($Container.position)
		]
	else:
		positions_to_protect = [
			tile_map.local_to_map($buddy.position),
			tile_map.local_to_map($Container.position)
		]

	for pos in positions_to_protect:
		for x_offset in range(-1, 2):
			for y_offset in range(-1, 2):
				safe_zone.append(pos + Vector2i(x_offset, y_offset))

	if Global.key:
		for i in range(5):
			var area = get_node("Area2D" + ("" if i == 0 else str(i + 1)))
			var key_cell = tile_map.local_to_map(area.position)
			for x_offset in range(-1, 2):
				for y_offset in range(-1, 2):
					safe_zone.append(key_cell + Vector2i(x_offset, y_offset))

	generate()
	


func is_in_safe_zone(cell: Vector2i) -> bool:
	for safe in safe_zone:
		if cell == safe:
			return true
	return false



func _on_settings_pressed() -> void:
	$Pause_menu.hide()
	$Settings_menu.show()
	
	
	
func _on_back_pressed():
	$Pause_menu.show()
	$Settings_menu.hide()



func _on_unstuck_pressed() -> void:
	$buddy.position = tile_map.map_to_local(tile_map.local_to_map($buddy.position))
	
