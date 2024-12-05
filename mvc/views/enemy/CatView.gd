# EyeballView.gd
extends Node2D
class_name CatView

var player: Player # Reference to the Player node

func set_player(player_ref: Player) -> void:
	player = player_ref
	if player:
		print("Player reference set in CatView:", player)
	else:
		print("Player reference is null in CatView.")

func _process(delta: float) -> void:
	if player:
		# Update any visual elements based on the player's position if needed
		var facing = (player.global_position - position).normalized()
		if facing.x < 0:
			$Sprite2D/AnimationPlayer.play("move_left")
		else:
			$Sprite2D/AnimationPlayer.play("move_right")
		pass
	else:
		print("Player reference is null in CatView.")
