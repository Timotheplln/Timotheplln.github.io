extends CharacterBody2D

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var activate_timer = $ActivateTimer
@onready var buddy = get_node("../buddy")
@onready var goal = get_node("../Container/goal")
@onready var tilemap = get_node("../TileMap")
@onready var agent = $NavigationAgent2D
@onready var footstep_timer = $FootstepTimer

var speed = 200
var can_move = false
var delay_frames = 30  

var position_history: Array = []
var destination

func _ready():
	
	animated_sprite_2d.play("down_ghost") 
	hide()
	$CollisionShape2D.disabled = true
	$kill/CollisionShape2D.disabled = true
	
	if Global.buddy:
		speed = 175
		_on_activate_timer_timeout()
		animated_sprite_2d.play("down") 
		

	if Global.ghost:
		speed = 200
		activate_timer.timeout.connect(_on_activate_timer_timeout)
		can_move = false
		set_process(false)
		set_physics_process(false)
		activate_timer.start(3.0) 

func _on_activate_timer_timeout():
	if Global.ghost:
		$".."._tp_ghost()
	show()
	animated_sprite_2d.play("down_ghost")
	await get_tree().create_timer(0.1).timeout
	$kill/CollisionShape2D.disabled = false
	$CollisionShape2D.disabled = false
	can_move = true
	set_process(true)
	set_physics_process(true)

func _physics_process(_delta):
	if not can_move or (Global.paused and !Global.ded) :
		velocity = Vector2.ZERO
		animated_sprite_2d.pause()
		return
	if Global.ded:
		velocity = Vector2.ZERO
		return
	
	if Global.ghost:
		position_history.append(buddy.global_position)
		
		if position_history.size() > delay_frames:
			var target_pos = position_history.pop_front()
			agent.target_position = target_pos
			
		var next_path_position = agent.get_next_path_position()
		var direction = (next_path_position - global_position).normalized()
		
		velocity = direction * speed

		if velocity.length() > 0:
			if abs(velocity.x) > abs(velocity.y):
				animated_sprite_2d.play("right_ghost" if velocity.x > 0 else "left_ghost")
			else:
				animated_sprite_2d.play("down_ghost" if velocity.y > 0 else "up_ghost")
		else:
			animated_sprite_2d.pause()
	elif Global.buddy:
		destination = goal.global_position

		agent.target_position = destination

		if agent.is_navigation_finished():
			velocity = Vector2.ZERO
		else:
			var next_path_position = agent.get_next_path_position()
			var direction = (next_path_position - global_position).normalized()
			velocity = direction * speed

		if velocity.length() > 0:
			if abs(velocity.x) > abs(velocity.y):
				animated_sprite_2d.play("right" if velocity.x > 0 else "left")
			else:
				animated_sprite_2d.play("down" if velocity.y > 0 else "up")
		else:
			animated_sprite_2d.pause()

	move_and_slide()
	if Global.buddy:
		if velocity.length() > 1:
			if footstep_timer.is_stopped():
				footstep_timer.start()
		else:
			animated_sprite_2d.pause()
			footstep_timer.stop()
			footstep_timer.wait_time = 0.01

func _play_animation_from_direction(dir: Vector2):
	if Global.ghost:
		if abs(dir.x) > abs(dir.y):
			animated_sprite_2d.play("right_ghost" if dir.x > 0 else "left_ghost")
		else:
			animated_sprite_2d.play("down_ghost" if dir.y > 0 else "up_ghost")
	else:
		if abs(dir.x) > abs(dir.y):
			animated_sprite_2d.play("right" if dir.x > 0 else "left")
		else:
			animated_sprite_2d.play("down" if dir.y > 0 else "up")

func _on_kill_body_entered(body: Node2D) -> void:
	if body.name == "buddy":
		if Global.ghost:
			body.on_ghost_touched()
		else:
			on_buddy_touched()

func on_buddy_touched():
	can_move = false
	animated_sprite_2d.play("ded")
	Global.ded = true
	$".."._trigger_victory()
