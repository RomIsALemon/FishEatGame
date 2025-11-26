extends CharacterBody2D

var level = 2
var scale_speed = 5

@onready var level_label = get_node("Label")

func _physics_process(delta):
	var target_scale := Vector2(1 + level/2.9, 1 + level/2.9)
	scale = scale.lerp(target_scale, scale_speed * delta)
	level_label.text = str(level)
	
