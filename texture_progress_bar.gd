extends TextureProgressBar

@onready var player = get_parent().get_parent().get_node("Player")
	
func _process(delta: float) -> void:
	value = (float(player.energy)/float(player.maxEnergy)) * 100
	print(value)
