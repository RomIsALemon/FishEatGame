extends CharacterBody2D

@export var level = 2
@export var dialogue = ""
var scale_speed = 5

@onready var level_label = get_node("Label")
@onready var speech_bubble = get_node("Speech Bubble")

func _ready():
	speech_bubble.hide()

func _physics_process(delta):
	var target_scale := Vector2(1 + level/2.9, 1 + level/2.9)
	scale = scale.lerp(target_scale, scale_speed * delta)
	level_label.text = str(level)
	


func _on_dialogue_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		speech_bubble.show()


func _on_dialogue_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		speech_bubble.hide()
