extends Node2D
class_name AsteroidView

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called when the node exits the scene tree
func _exit_tree() -> void:
	GlobalSoundsManager.sfx_explosion()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
