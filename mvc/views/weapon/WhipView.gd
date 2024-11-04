extends Node2D
class_name WhipView


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GlobalSoundsManager.sfx_bullet()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	# doesn't really need to do anything special
	pass


func slam_effect() -> void:
	$Sprite2D/AnimationPlayer.play("slam")
