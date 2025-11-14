extends CharacterBody2D

var level = 2

@onready var level_label = get_node("Label")

func _physics_process(delta):
	scale.x = 1.265 + level/3.5
	scale.y = 1.265 + level/3.5
	level_label.text = str(level)
	
