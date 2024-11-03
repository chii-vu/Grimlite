extends Node2D
class_name EyeballView

var player: Player  # Reference to the player node

func set_player(player_ref: Player) -> void:
	player = player_ref
	if player:
		print("Player reference set in EyeballView:", player)
	else:
		print("Player reference is null in EyeballView.")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called when the node exits the scene tree
func _exit_tree() -> void:
	GlobalSoundsManager.sfx_explosion()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	var facing = (player.position-position)
	if facing.y < 0 :
		$EyeballView/Sprite2D/AnimationPlayer.play("move_right")
		print(facing.y)

	else:
		$EyeballView/Sprite2D/AnimationPlayer.play("move_left")
		print(facing.y)
