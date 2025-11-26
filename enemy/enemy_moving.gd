extends CharacterBody2D

var level = 2
var scale_speed = 5
var player_in_range = false
var speed = 70.0

@onready var level_label = get_node("Label")
@onready var player = get_parent().get_node("Player")

func _ready():
	$Area2D.body_entered.connect(_on_body_entered)
	$Area2D.body_exited.connect(_on_body_exited)

func _physics_process(delta):
	var target_scale := Vector2(1 + level/2.9, 1 + level/2.9)
	scale = scale.lerp(target_scale, scale_speed * delta)
	level_label.text = str(level)
	if(player_in_range):
		look_at(player.global_position)
		if(velocity.x < 0):
			$AnimatedSprite2D.flip_v = true
			$AnimatedSprite2D.flip_h = true
		else:
			$AnimatedSprite2D.flip_v = false
			$AnimatedSprite2D.flip_h = true
		if(player.currentlevel < level):
			var direction = (player.global_position - global_position).normalized()
			velocity = (direction * speed)
	else:
		velocity = Vector2.ZERO
	move_and_slide()
	
func _on_body_entered(body):
	if body.is_in_group("Player"):
		player_in_range = true

func _on_body_exited(body):
	if body.is_in_group("Player"):
		player_in_range = false
