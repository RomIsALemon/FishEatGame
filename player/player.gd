extends CharacterBody2D


var speed = 150.0
var mouse_position = null
var level = 5 # true level
var currentlevel = level # displayed level and temporary level
var can_use_powerup = true

@onready var level_label = get_node("Label")
@onready var camera = get_node("Camera2D")

func _physics_process(delta):
	scale.x = 1 + currentlevel/3.5
	scale.y = 1 + currentlevel/3.5
	# work on camera zooming out depending on fish scale
	camera.zoom.x = ((camera.get_viewport().size.x/100) / scale.x)
	camera.zoom.y = ((camera.get_viewport().size.y/54) / scale.y)
	level_label.text = str(currentlevel)
	mouse_position = get_global_mouse_position()
	var direction = (mouse_position - position).normalized()
	velocity = (direction * speed)
	self.look_at(mouse_position)
	if Input.is_action_just_pressed("ui_accept") and can_use_powerup and level >= 10:
		dash()
	move_and_slide()
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		if collision.get_collider().get_class() == "CharacterBody2D":
			_process_collision(collision.get_collider())
			break

func _process_collision(enemy):
	var en_level = enemy.level
	if currentlevel > en_level:
		level = level + en_level
		if can_use_powerup == true:
			currentlevel = level
		enemy.queue_free()
	else:
		get_tree().change_scene_to_file("res://gameover.tscn")
		
		
func wait(seconds: float) -> void:
	await get_tree().create_timer(seconds).timeout
	
func dash():
	can_use_powerup = false
	level_label.add_theme_color_override("font_color", Color(0,1,0))
	print("Level: ", level)
	currentlevel = int(level * 1.5)
	level -= int(level/8)
	speed = 400
	await wait(1)
	speed = 250
	currentlevel = level
	level_label.add_theme_color_override("font_color", Color(1,1,1))
	can_use_powerup = true
	print("Level: ", level)
