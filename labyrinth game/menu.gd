extends Node2D

var old_size: Vector2
var old_screen:= Vector2.ZERO
var initial_positions := {}



func _ready():
	Global.load_game()
	Global.inverted = false
	Global.separated_control = false
	Global.invis = false
	Global.anno_un = false #a litle reference for manga readers (it means unknown for those who don't know)
	Global.ghost = false
	Global.buddy = false
	Global.key = false
	Global.move = false
	Global.moving = false
	$CanvasLayer/settings_menu/volume.value = Global.slider
	$CanvasLayer/choises/hint.button_pressed = Global.hint
	var tile_map = $TileMap
	generate(tile_map)
	$CanvasLayer/CanvasGroup2.hide()
	$CanvasLayer/custom_scene.hide()
	$CanvasLayer/Challenges.hide()
	$CanvasLayer/choises.hide()
	$CanvasLayer/settings_menu.hide()
	$CanvasLayer/custom_scene/width_choice.min_value = 5
	$CanvasLayer/custom_scene/width_choice.max_value = 1000
	$CanvasLayer/custom_scene/width_choice.step = 1
	$CanvasLayer/custom_scene/height_choice.min_value = 5
	$CanvasLayer/custom_scene/height_choice.max_value = 1000
	$CanvasLayer/custom_scene/height_choice.step = 1
	$CanvasLayer/choises/width_choice.min_value = 5
	$CanvasLayer/choises/width_choice.max_value = 1000
	$CanvasLayer/choises/width_choice.step = 1
	$CanvasLayer/choises/height_choice.min_value = 5
	$CanvasLayer/choises/height_choice.max_value = 1000
	$CanvasLayer/choises/height_choice.step = 1
	$CanvasLayer/choises/width_choice.value = 15
	$CanvasLayer/choises/height_choice.value = 15
	$CanvasLayer/CanvasGroup/PLAY.pressed.connect(_on_play_pressed)
	$CanvasLayer/CanvasGroup/Challenge.pressed.connect(_on_challenges_pressed)
	$CanvasLayer/CanvasGroup/Settings.pressed.connect(_on_settings_pressed)
	$CanvasLayer/settings_menu/Back.pressed.connect(_on_back_settings_pressed)
	$CanvasLayer/settings_menu/volume.connect("value_changed", Callable(self, "_on_volume_changed"))
	$CanvasLayer/settings_menu/volume_victory.connect("value_changed", Callable(self, "_on_volume_victory_changed"))
	$CanvasLayer/CanvasGroup/Quit.pressed.connect(_on_quit_pressed)
	$CanvasLayer/CanvasGroup2/Easy.pressed.connect(_on_easy_pressed)
	$CanvasLayer/CanvasGroup2/Normal.pressed.connect(_on_normal_pressed)
	$CanvasLayer/CanvasGroup2/Hard.pressed.connect(_on_hard_pressed)
	$CanvasLayer/CanvasGroup2/Back.pressed.connect(_on_back_pressed)
	$CanvasLayer/CanvasGroup2/custom.pressed.connect(_on_custom_pressed)
	$CanvasLayer/custom_scene/Back.pressed.connect(_on_back2_pressed)
	$CanvasLayer/custom_scene/OK.pressed.connect(_on_ok_pressed)
	$CanvasLayer/Challenges/Back.pressed.connect(_on_back3_pressed)
	$"CanvasLayer/Challenges/inverted control".pressed.connect(_on_inverted_pressed)
	$"CanvasLayer/Challenges/unknown maze".pressed.connect(_on_anno_un_pressed)
	$"CanvasLayer/Challenges/invisible maze".pressed.connect(_on_invisible_pressed)
	$"CanvasLayer/Challenges/moving maze".pressed.connect(_on_moving_pressed)
	$"CanvasLayer/Challenges/escape the ghost (follower)".pressed.connect(_on_ghost_pressed)
	$"CanvasLayer/Challenges/chase buddy".pressed.connect(_on_buddy_pressed)
	$"CanvasLayer/Challenges/piece the key".pressed.connect(_on_piece_the_key_pressed)
	$"CanvasLayer/Challenges/where is my camera".pressed.connect(_on_sep_cam_pressed)
	$CanvasLayer/choises/OK.pressed.connect(_on_choice_ok_pressed)
	$CanvasLayer/choises/Back.pressed.connect(_on_choice_back_pressed)
	_full_first_pos()
	old_size = get_viewport().get_visible_rect().size



func _on_play_pressed():
	$CanvasLayer/CanvasGroup2.show()
	$CanvasLayer/CanvasGroup.hide()
	
	
	
func _on_challenges_pressed():
	$CanvasLayer/CanvasGroup.hide()
	$CanvasLayer/Challenges.show()
	
	
	
func _on_settings_pressed():
	$CanvasLayer/CanvasGroup.hide()
	$CanvasLayer/settings_menu.show()
	
	
	
func _on_back_settings_pressed():
	$CanvasLayer/CanvasGroup.show()
	$CanvasLayer/settings_menu.hide()



func _on_volume_changed(value):
	Global.slider = value
	var vol = "Master"
	var db = linear_to_db(value / 100.0)
	Global._volume_change(vol, db)
	
	
	
func _on_volume_victory_changed(value):
	Global.slider = value
	var vol = "victory"
	var db = linear_to_db(value / 100.0)
	Global._volume_change(vol, db)



func _on_quit_pressed():
	get_tree().quit()



func _on_back_pressed():
	$CanvasLayer/CanvasGroup.show()
	$CanvasLayer/CanvasGroup2.hide()
	
	
	
func _on_back2_pressed():
	$CanvasLayer/CanvasGroup2.show()
	$CanvasLayer/custom_scene.hide()
	
	
	
func _on_easy_pressed():
	Global.inverted = false
	Global.separated_control = false
	Global.challenge = "none"
	Global.maze_height = 5
	Global.maze_width = 5
	get_tree().change_scene_to_file("res://mon_jeu.tscn")
	
	
	
func _on_normal_pressed():
	Global.inverted = false
	Global.separated_control = false
	Global.maze_height = 20
	Global.maze_width = 20
	get_tree().change_scene_to_file("res://mon_jeu.tscn")
	
	
	
func _on_hard_pressed():
	Global.inverted = false
	Global.separated_control = false
	Global.maze_height = 100
	Global.maze_width = 100
	get_tree().change_scene_to_file("res://mon_jeu.tscn")
	
	
	
func _on_custom_pressed():
	$CanvasLayer/CanvasGroup2.hide()
	$CanvasLayer/custom_scene.show()
	
	
	
func _set_first_position(control: Control):
	var screen_size = Vector2(get_viewport().get_visible_rect().size)
	initial_positions[control] = control.position 

	control.position += screen_size / 2 + control.size / 2



func _set_position(control: Control):
	var screen_size = Vector2(get_viewport().get_visible_rect().size)
	
	control.position = initial_positions[control]
	control.position += screen_size / 2 + control.size / 2
	
	
	
func _set_first_position_right(control: Control):
	var screen_size = Vector2(get_viewport().get_visible_rect().size)
	initial_positions[control] = control.position 

	control.position += Vector2(((screen_size.x * 3) / 4),(screen_size.y / 2)) + control.size / 2 - Vector2(control.size.x,0)



func _set_position_right(control: Control):
	var screen_size = Vector2(get_viewport().get_visible_rect().size)
	
	control.position = initial_positions[control]
	control.position += Vector2(((screen_size.x * 3) / 4),(screen_size.y / 2)) + control.size / 2 - Vector2(control.size.x,0)



func _set_first_position_left(control: Control):
	var screen_size = Vector2(get_viewport().get_visible_rect().size)
	initial_positions[control] = control.position 

	control.position += Vector2((screen_size.x / 4),(screen_size.y / 2)) + control.size / 2



func _set_position_left(control: Control):
	var screen_size = Vector2(get_viewport().get_visible_rect().size)
	
	control.position = initial_positions[control]
	control.position += Vector2((screen_size.x / 4),(screen_size.y / 2)) + control.size / 2



func _full_pos():
	_set_position($CanvasLayer/CanvasGroup2/Back)
	_set_position($CanvasLayer/CanvasGroup2/Easy)
	_set_position($CanvasLayer/CanvasGroup2/Normal)
	_set_position($CanvasLayer/CanvasGroup2/Hard)
	_set_position($CanvasLayer/CanvasGroup2/custom)
	_set_position($CanvasLayer/CanvasGroup/PLAY)
	_set_position($CanvasLayer/CanvasGroup/Challenge)
	_set_position($CanvasLayer/CanvasGroup/Settings)
	_set_position($CanvasLayer/CanvasGroup/Quit)
	_set_position($CanvasLayer/CanvasGroup/Label)
	_set_position($CanvasLayer/custom_scene/height_choice)
	_set_position($CanvasLayer/custom_scene/width_choice)
	_set_position($CanvasLayer/custom_scene/Back)
	_set_position($CanvasLayer/custom_scene/OK)
	_set_position($CanvasLayer/Challenges/Back)
	_set_position($CanvasLayer/Challenges/Label)
	_set_position($"CanvasLayer/choises/ColorRect")
	_set_position($CanvasLayer/choises/OK)
	_set_position($CanvasLayer/choises/Back)
	_set_position($CanvasLayer/choises/hint)
	_set_position($CanvasLayer/settings_menu/Master)
	_set_position($CanvasLayer/settings_menu/volume)
	_set_position($CanvasLayer/settings_menu/victory)
	_set_position($CanvasLayer/settings_menu/volume_victory)
	_set_position($CanvasLayer/settings_menu/erase_save)
	_set_position($CanvasLayer/settings_menu/Back)
	_set_position_left($"CanvasLayer/Challenges/inverted control")
	_set_position_left($"CanvasLayer/Challenges/blind maze")
	_set_position_left($"CanvasLayer/Challenges/moving maze")
	_set_position_left($"CanvasLayer/Challenges/chase buddy")
	_set_position_left($"CanvasLayer/Challenges/piece the key")
	_set_position_right($"CanvasLayer/Challenges/unknown maze")
	_set_position_right($"CanvasLayer/Challenges/invisible maze")
	_set_position_right($"CanvasLayer/Challenges/escape the ghost (follower)")
	_set_position_right($"CanvasLayer/Challenges/portals galore")
	_set_position_right($"CanvasLayer/Challenges/where is my camera")
	_set_position_left($CanvasLayer/choises/width_choice)
	_set_position_right($CanvasLayer/choises/height_choice)
	
	
	
func _full_first_pos():
	_set_first_position($CanvasLayer/CanvasGroup2/Back)
	_set_first_position($CanvasLayer/CanvasGroup2/Easy)
	_set_first_position($CanvasLayer/CanvasGroup2/Normal)
	_set_first_position($CanvasLayer/CanvasGroup2/Hard)
	_set_first_position($CanvasLayer/CanvasGroup2/custom)
	_set_first_position($CanvasLayer/CanvasGroup/PLAY)
	_set_first_position($CanvasLayer/CanvasGroup/Challenge)
	_set_first_position($CanvasLayer/CanvasGroup/Settings)
	_set_first_position($CanvasLayer/CanvasGroup/Quit)
	_set_first_position($CanvasLayer/CanvasGroup/Label)
	_set_first_position($CanvasLayer/custom_scene/height_choice)
	_set_first_position($CanvasLayer/custom_scene/width_choice)
	_set_first_position($CanvasLayer/custom_scene/Back)
	_set_first_position($CanvasLayer/custom_scene/OK)
	_set_first_position($CanvasLayer/Challenges/Back)
	_set_first_position($CanvasLayer/Challenges/Label)
	_set_first_position($"CanvasLayer/choises/ColorRect")
	_set_first_position($CanvasLayer/choises/OK)
	_set_first_position($CanvasLayer/choises/Back)
	_set_first_position($CanvasLayer/choises/hint)
	_set_first_position($CanvasLayer/settings_menu/Master)
	_set_first_position($CanvasLayer/settings_menu/volume)
	_set_first_position($CanvasLayer/settings_menu/victory)
	_set_first_position($CanvasLayer/settings_menu/volume_victory)
	_set_first_position($CanvasLayer/settings_menu/erase_save)
	_set_first_position($CanvasLayer/settings_menu/Back)
	_set_first_position_left($"CanvasLayer/Challenges/inverted control")
	_set_first_position_left($"CanvasLayer/Challenges/blind maze")
	_set_first_position_left($"CanvasLayer/Challenges/moving maze")
	_set_first_position_left($"CanvasLayer/Challenges/escape the ghost (follower)")
	_set_first_position_left($"CanvasLayer/Challenges/piece the key")
	_set_first_position_right($"CanvasLayer/Challenges/unknown maze")
	_set_first_position_right($"CanvasLayer/Challenges/invisible maze")
	_set_first_position_right($"CanvasLayer/Challenges/chase buddy")
	_set_first_position_right($"CanvasLayer/Challenges/portals galore")
	_set_first_position_right($"CanvasLayer/Challenges/where is my camera")
	_set_first_position_left($CanvasLayer/choises/width_choice)
	_set_first_position_right($CanvasLayer/choises/height_choice)
	
	
	
func _process(_delta):
	$CanvasLayer/choises/hint.button_pressed = Global.hint
	var screen_size = Vector2(get_viewport().get_visible_rect().size)
	if screen_size != old_size:
		_full_pos()
		old_size = screen_size
	
		
		
func _on_line_edit_gui_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		var chara = OS.get_keycode_string(event.keycode)
		var allowed_keys = [KEY_BACKSPACE, KEY_DELETE, KEY_LEFT, KEY_RIGHT, KEY_TAB]
				
		if not (chara.is_valid_int() and chara.length() == 1) and event.keycode not in allowed_keys:
			get_viewport().set_input_as_handled()
			
			
			
func _on_ok_pressed():
	Global.inverted = false
	Global.separated_control = false
	Global.challenge = "none"
	Global.maze_height = $CanvasLayer/custom_scene/height_choice.value
	Global.maze_width = $CanvasLayer/custom_scene/width_choice.value
	get_tree().change_scene_to_file("res://mon_jeu.tscn")
	
	
	
func _on_back3_pressed():
	$CanvasLayer/CanvasGroup.show()
	$CanvasLayer/Challenges.hide()
	
	
	
func _on_inverted_pressed():
	Global.inverted = true
	$"CanvasLayer/choises/ColorRect/Challenge description".text = "Your right is your left, your up is your down and of course the opposite is also true"
	_set_position($"CanvasLayer/choises/ColorRect")
	_on_challenge_pressed()
	
	
	
func _on_anno_un_pressed():
	Global.anno_un = true
	$"CanvasLayer/choises/ColorRect/Challenge description".text = "You don't know the path so you have to search for it"
	_set_position($"CanvasLayer/choises/ColorRect")
	_on_challenge_pressed()
	
	
	
func _on_invisible_pressed():
	Global.invis = true
	$"CanvasLayer/choises/ColorRect/Challenge description".text = "No walls are visible but if you see the end you can go straight... right?"
	_set_position($"CanvasLayer/choises/ColorRect")
	_on_challenge_pressed()



func _on_moving_pressed():
	Global.moving = true
	$"CanvasLayer/choises/ColorRect/Challenge description".text = "Every 10 seconds the walls are moving.\nWill you be able to reach the end before the path changes?"
	_set_position($"CanvasLayer/choises/ColorRect")
	_on_challenge_pressed()
	
	
	
func _on_ghost_pressed():
	Global.ghost = true
	$"CanvasLayer/choises/ColorRect/Challenge description".text = "RUN, YOU'RE GETTING CHASED BY A GHOST!!!"
	_set_position($"CanvasLayer/choises/ColorRect")
	_on_challenge_pressed()



func _on_buddy_pressed():
	Global.buddy = true
	$"CanvasLayer/choises/ColorRect/Challenge description".text = "RUN, YOU'RE GETTING CHASED BY... oh no, YOU ARE THE GHOST NOW CHASE HIM FAST BEFORE HE WINS!"
	_set_position($"CanvasLayer/choises/ColorRect")
	_on_challenge_pressed()



func _on_piece_the_key_pressed():
	Global.key = true
	$"CanvasLayer/choises/ColorRect/Challenge description".text = "The key is broken into 5 pieces, go find them all to open the door" #"The key to the end door has been broken into 5 pieces, go find them all to open the door"
	_set_position($"CanvasLayer/choises/ColorRect")
	_on_challenge_pressed()
	
	
	
func _on_sep_cam_pressed():
	Global.separated_control = true
	$"CanvasLayer/choises/ColorRect/Challenge description".text = "Where are you? I don't see you, you'll have to search for yourself"
	_set_position($"CanvasLayer/choises/ColorRect")
	_on_challenge_pressed()



func _on_challenge_pressed():
	$CanvasLayer/Challenges.hide()
	$CanvasLayer/choises.show()
	if Global.inverted == true:
		$CanvasLayer/Control/Sprite2D.texture = preload("res://key_inverted.png")
		
		
		
func _on_choice_ok_pressed():
	Global.maze_height = $CanvasLayer/choises/height_choice.value
	Global.maze_width = $CanvasLayer/choises/width_choice.value
	Global.save_game()
	get_tree().change_scene_to_file("res://mon_jeu.tscn")
	
	
	
func _on_choice_back_pressed():
	$CanvasLayer/Challenges.show()
	$CanvasLayer/choises.hide()
	Global.inverted = false
	Global.separated_control = false
	Global.invis = false
	Global.anno_un = false #a litle reference for manga readers (it means unknown for those who don't know)
	Global.ghost = false
	Global.buddy = false
	Global.key = false
	Global.move = false
	Global.moving = false
	$CanvasLayer/Control/Sprite2D.texture = preload("res://key.png")
	
	
	
func generate(tile_map: TileMap):
	var visited : Array
	var search_stack : Array
	var connections = {}
	
	var all_points = []
	for i in range(100 * 100):
		var x = i % 100
		var y = floor(float(i) / float(100))
		var point = Vector2i(x, y)
		
		all_points.push_back(point)
		connections[point] = 0b0000  
		
	var start = all_points[randi() % all_points.size()]
	search_stack = [start]
	visited = [start]
	for i in range(100):
		tile_map.set_cell(0, Vector2i(-1, i), 2, Vector2i(0, 0))
		tile_map.set_cell(0, Vector2i(100, i), 2, Vector2i(0, 0))
	for i in range(100):
		tile_map.set_cell(0, Vector2i(i, -1), 2, Vector2i(0, 0))
		tile_map.set_cell(0, Vector2i(i, 100), 2, Vector2i(0, 0))
	tile_map.set_cell(0, Vector2i(-1, -1), 2, Vector2i(0, 0))
	tile_map.set_cell(0, Vector2i(100, -1), 2, Vector2i(0, 0))
	tile_map.set_cell(0, Vector2i(-1, 100), 2, Vector2i(0, 0))
	tile_map.set_cell(0, Vector2i(100, 100), 2, Vector2i(0, 0))
	
	
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
	for point in all_points:
		var conns = connections[point]
		tile_map.set_cell(0, point, 2, Vector2i(int(conns), 0))



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
			or candidate.x >= 100
			or candidate.y < 0
			or candidate.y >= 100):
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
	


func _on_inverted_control_mouse_entered() -> void:
	$CanvasLayer/Control/Sprite2D.texture = preload("res://key_inverted.png")



func _on_inverted_control_mouse_exited() -> void:
	$CanvasLayer/Control/Sprite2D.texture = preload("res://key.png")



func _on_hint_toggled(toggled_on: bool) -> void:
	if toggled_on:
		Global.hint = true
	else:
		Global.hint = false
	Global.save_game()



func _on_erase_save_pressed() -> void:
	Global._empty_save()



#func _unhandled_input(event):
#	if event.is_action_pressed("ui_down"):
#		_select_next()
#	elif event.is_action_pressed("ui_up"):
#		_select_previous()



#func _select_next():
#	var current = get_tree().get_focus_owner()
#	if current and current.focus_next:
#		current.focus_next.grab_focus()



#func _select_previous():
#	var current = get_tree().get_focus_owner()
#	if current and current.focus_previous:
#		current.focus_previous.grab_focus()
