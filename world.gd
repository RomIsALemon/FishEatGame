extends Node2D

@onready var player = get_node("Player")
@onready var enemies = []



# Called when the node enters the scene tree for the first time.
func _ready():
	enemies.append(get_node("Enemy"))
	enemies.append(get_node("Enemy2"))
	enemies.append(get_node("Enemy4"))
	enemies[0].level = 1
	enemies[1].level = 1
	enemies[2].level = 6
	enemies.append(get_node("Enemy_Moving"))
	enemies[3].level = 3


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$CanvasLayer/LabelCurLvl.text = "Displayed Level: " + str(player.currentlevel)
	$CanvasLayer/LabelLvl.text = "True Level: " + str(player.level)
	pass
