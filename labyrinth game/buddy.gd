extends CharacterBody2D
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var activate_timer = $ActivateTimer
@onready var footstep_timer = $FootstepTimer

var can_move = true
var speed = 200  # Vitesse de déplacement
var key_part = 0

func _ready():
	$arrow.hide()
	if Global.buddy:
		animated_sprite_2d.play("down_ghost") 
		hide()
		$CollisionShape2D.disabled = true
		$Area2D/CollisionShape2D.disabled = true
		
		activate_timer.timeout.connect(_on_activate_timer_timeout)
		can_move = false
		set_process(false)
		set_physics_process(false)
		activate_timer.start(3.0) 
		
func _on_activate_timer_timeout():
	show()
	animated_sprite_2d.play("down_ghost")
	await get_tree().create_timer(0.1).timeout
	$Area2D/CollisionShape2D.disabled = false
	$CollisionShape2D.disabled = false
	can_move = true
	set_process(true)
	set_physics_process(true)
	

func _physics_process(_delta):

	if not can_move:
		velocity = Vector2.ZERO
		return

	if !Global.buddy:
		speed = 200
		var input_vector = Vector2(
			int(Input.is_action_pressed("Right")) - int(Input.is_action_pressed("Left")),
			int(Input.is_action_pressed("Down")) - int(Input.is_action_pressed("Up"))
		)
		var sep_input_vector = Vector2(
			int(Input.is_action_pressed("Right_player")) - int(Input.is_action_pressed("Left_player")),
			int(Input.is_action_pressed("Down_player")) - int(Input.is_action_pressed("Up_player"))
		)
		

		if Global.inverted:
			if Global.separated_control:
				if Input.is_action_pressed("Right_player"):
					animated_sprite_2d.play("left")
				if Input.is_action_pressed("Left_player"):
					animated_sprite_2d.play("right")
				if Input.is_action_pressed("Down_player"):
					animated_sprite_2d.play("up")
				if Input.is_action_pressed("Up_player"):
					animated_sprite_2d.play("down")
			else:
				if Input.is_action_pressed("Right"):
					animated_sprite_2d.play("left")
				if Input.is_action_pressed("Left"):
					animated_sprite_2d.play("right")
				if Input.is_action_pressed("Down"):
					animated_sprite_2d.play("up")
				if Input.is_action_pressed("Up"):
					animated_sprite_2d.play("down")
		else:
			if Global.separated_control:
				if Input.is_action_pressed("Right_player"):
					animated_sprite_2d.play("right")
				if Input.is_action_pressed("Left_player"):
					animated_sprite_2d.play("left")
				if Input.is_action_pressed("Down_player"):
					animated_sprite_2d.play("down")
				if Input.is_action_pressed("Up_player"):
					animated_sprite_2d.play("up")
			else:
				if Input.is_action_pressed("Right"):
					animated_sprite_2d.play("right")
				if Input.is_action_pressed("Left"):
					animated_sprite_2d.play("left")
				if Input.is_action_pressed("Down"):
					animated_sprite_2d.play("down")
				if Input.is_action_pressed("Up"):
					animated_sprite_2d.play("up")
			
	# Normalisation pour éviter les mouvements plus rapides en diagonale
		if input_vector.length() > 0:
			input_vector = input_vector.normalized()
		
		# Appliquer la vitesse
		if Global.inverted:
			if Global.separated_control:
				velocity = -sep_input_vector * speed
			else:
				velocity = -input_vector * speed
		else:
			if Global.separated_control:
				velocity = sep_input_vector * speed
			else:
				velocity = input_vector * speed
				
		
	else:
		speed = 250
		var input_vector_ghost = Vector2(
			int(Input.is_action_pressed("Right")) - int(Input.is_action_pressed("Left")),
			int(Input.is_action_pressed("Down")) - int(Input.is_action_pressed("Up"))
		)
		var sep_input_vector_ghost = Vector2(
			int(Input.is_action_pressed("Right_player")) - int(Input.is_action_pressed("Left_player")),
			int(Input.is_action_pressed("Down_player")) - int(Input.is_action_pressed("Up_player"))
		)
		
		if Global.inverted:
			if Global.separated_control:
				if Input.is_action_pressed("Right_player"):
					animated_sprite_2d.play("left_ghost")
				if Input.is_action_pressed("Left_player"):
					animated_sprite_2d.play("right_ghost")
				if Input.is_action_pressed("Down_player"):
					animated_sprite_2d.play("up_ghost")
				if Input.is_action_pressed("Up_player"):
					animated_sprite_2d.play("down_ghost")
				if Input.is_action_just_released("Right_player"):
					animated_sprite_2d.pause()
				if Input.is_action_just_released("Left_player"):
					animated_sprite_2d.pause()
				if Input.is_action_just_released("Down_player"):
					animated_sprite_2d.pause()
				if Input.is_action_just_released("Up_player"):
					animated_sprite_2d.pause()
			else:
				if Input.is_action_pressed("Right"):
					animated_sprite_2d.play("left_ghost")
				if Input.is_action_pressed("Left"):
					animated_sprite_2d.play("right_ghost")
				if Input.is_action_pressed("Down"):
					animated_sprite_2d.play("up_ghost")
				if Input.is_action_pressed("Up"):
					animated_sprite_2d.play("down_ghost")
				if Input.is_action_just_released("Right"):
					animated_sprite_2d.pause()
				if Input.is_action_just_released("Left"):
					animated_sprite_2d.pause()
				if Input.is_action_just_released("Down"):
					animated_sprite_2d.pause()
				if Input.is_action_just_released("Up"):
					animated_sprite_2d.pause()
		else:
			if Global.separated_control:
				if Input.is_action_pressed("Right_player"):
					animated_sprite_2d.play("right_ghost")
				if Input.is_action_pressed("Left_player"):
					animated_sprite_2d.play("left_ghost")
				if Input.is_action_pressed("Down_player"):
					animated_sprite_2d.play("down_ghost")
				if Input.is_action_pressed("Up_player"):
					animated_sprite_2d.play("up_ghost")
				if Input.is_action_just_released("Right_player"):
					animated_sprite_2d.pause()
				if Input.is_action_just_released("Left_player"):
					animated_sprite_2d.pause()
				if Input.is_action_just_released("Down_player"):
					animated_sprite_2d.pause()
				if Input.is_action_just_released("Up_player"):
					animated_sprite_2d.pause()
			else:
				if Input.is_action_pressed("Right"):
					animated_sprite_2d.play("right_ghost")
				if Input.is_action_pressed("Left"):
					animated_sprite_2d.play("left_ghost")
				if Input.is_action_pressed("Down"):
					animated_sprite_2d.play("down_ghost")
				if Input.is_action_pressed("Up"):
					animated_sprite_2d.play("up_ghost")
				if Input.is_action_just_released("Right"):
					animated_sprite_2d.pause()
				if Input.is_action_just_released("Left"):
					animated_sprite_2d.pause()
				if Input.is_action_just_released("Down"):
					animated_sprite_2d.pause()
				if Input.is_action_just_released("Up"):
					animated_sprite_2d.pause()
			
	# Normalisation pour éviter les mouvements plus rapides en diagonale
		if input_vector_ghost.length() > 0:
			input_vector_ghost = input_vector_ghost.normalized()
		
		# Appliquer la vitesse
		if Global.inverted:
			if Global.separated_control:
				velocity = -sep_input_vector_ghost * speed
			else:
				velocity = -input_vector_ghost * speed
		else:
			if Global.separated_control:
				velocity = sep_input_vector_ghost * speed
			else:
				velocity = input_vector_ghost * speed
	
	# Déplacement avec gestion des collisions
	move_and_slide()
	if !Global.buddy:
		if velocity.length() > 1:
			if footstep_timer.is_stopped():
				footstep_timer.start()
		else:
			animated_sprite_2d.pause()
			footstep_timer.stop()
			footstep_timer.wait_time = 0.01

func _on_goal_body_entered(body: Node2D) -> void:
	if body.name == "buddy":
		can_move = false
		animated_sprite_2d.pause()
		$".."._trigger_victory()
	elif body.name == "ghost":
		can_move = false
		animated_sprite_2d.pause()
		$".."._on_game_over()
		

func on_ghost_touched():
	can_move = false
	animated_sprite_2d.play("ded")
	Global.ded = true
	$".."._on_game_over()


func _on_area_2d_body_entered(_body: Node2D) -> void:
	$"../Area2D".hide()
	$"../UI/key_sprites/Key_frag1".show()
	$"../Area2D".queue_free()
	key_part += 1
	if key_part >= 5:
		Global.key_found = true


func _on_area_2d_2_body_entered(_body: Node2D) -> void:
	$"../Area2D2".hide()
	$"../UI/key_sprites/Key_frag2".show()
	$"../Area2D2".queue_free()
	key_part += 1
	if key_part >= 5:
		Global.key_found = true


func _on_area_2d_3_body_entered(_body: Node2D) -> void:
	$"../Area2D3".hide()
	$"../UI/key_sprites/Key_frag3".show()
	$"../Area2D3".queue_free()
	key_part += 1
	if key_part >= 5:
		Global.key_found = true


func _on_area_2d_4_body_entered(_body: Node2D) -> void:
	$"../Area2D4".hide()
	$"../UI/key_sprites/Key_frag4".show()
	$"../Area2D4".queue_free()
	key_part += 1
	if key_part >= 5:
		Global.key_found = true


func _on_area_2d_5_body_entered(_body: Node2D) -> void:
	$"../Area2D5".hide()
	$"../UI/key_sprites/Key_frag5".show()
	$"../Area2D5".queue_free()
	key_part += 1
	if key_part >= 5:
		Global.key_found = true


#func _on_kill_body_entered(_body: Node2D) -> void:
#	$"../ghost/kill".queue_free()
#	on_ghost_touched()

func _process(_delta):
	var direction
	if !Global.buddy:
		direction = $"../Container/goal".global_position - global_position
	else:
		direction = $"../ghost".global_position - global_position
	$arrow.rotation = direction.angle()
