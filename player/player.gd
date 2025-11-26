extends CharacterBody2D


var basespeed = 100.0 # speed stat
var speed = basespeed # current speed
var mouse_position = null
var level = 2 # true level
var currentlevel = level # displayed level and temporary level
var can_use_powerup = true
var scaleSpeed = 5
var toggleMove = true
var speedModifier = 1
var mousedeadzone = 10.0

@onready var level_label = get_node("Label")
@onready var camera = get_node("Camera2D")

func _physics_process(delta):
	var target_scale := Vector2(1 + currentlevel/2.9, 1 + currentlevel/2.9)
	scale = scale.lerp(target_scale, scaleSpeed * delta)
	camera.zoom.x = ((camera.get_viewport().size.x/200) / scale.x)
	camera.zoom.y = ((camera.get_viewport().size.y/115) / scale.y)
	level_label.text = str(currentlevel)
	mouse_position = get_global_mouse_position()
	var mousediff := position.distance_to(mouse_position)
	var maxdist = 100.0
	var d = clamp(mousediff, 0.0, basespeed)
	if(mousediff > mousedeadzone):
		speed = lerp(mousedeadzone, basespeed, d / maxdist)
	else:
		speed = 0
	var direction = (mouse_position - position).normalized()
	velocity = (direction * (speed * speedModifier))
	self.look_at(mouse_position)
	print(mousediff)
	if(direction.x < 0):
		$AnimatedSprite2D.flip_v = true
	else:
		$AnimatedSprite2D.flip_v = false
	if Input.is_action_just_pressed("Dash") and can_use_powerup and level >= 5:
		dash()
	if Input.is_action_just_pressed("Puff Up") and can_use_powerup and level >= 10:
		puff_up()
	if Input.is_action_just_pressed("Toggle Movement"):
		toggleMove = not toggleMove
	if toggleMove == true:
		move_and_slide()
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		if collision.get_collider().is_in_group("Enemy"):
			_process_collision(collision.get_collider())
			break

func _process_collision(enemy):
	var en_level = enemy.level
	if currentlevel > en_level:
		level = level + en_level
		if can_use_powerup == true:
			currentlevel = level
		enemy.queue_free()
	elif currentlevel == en_level:
		print("Equal")
	else:
		get_tree().change_scene_to_file("res://gameover.tscn")
		
		
func wait(seconds: float) -> void:
	await get_tree().create_timer(seconds).timeout
	
func dash():
	can_use_powerup = false
	speedModifier = 3
	await wait(0.3)
	speedModifier = 1
	can_use_powerup = true
	currentlevel = level
	
func puff_up():
	can_use_powerup = false
	level_label.add_theme_color_override("font_color", Color(0,1,0))
	currentlevel = int(level * 1.5)
	level -= int(level/8)
	await wait(2)
	currentlevel = level
	level_label.add_theme_color_override("font_color", Color(1,1,1))
	can_use_powerup = true
