# EyeballView.gd
extends Node2D
class_name EyeballView

var player: Player  # Reference to the Player node

func set_player(player_ref: Player) -> void:
	player = player_ref
	if player:
		print("Player reference set in EyeballView:", player)
	else:
		print("Player reference is null in EyeballView.")

func _process(delta: float) -> void:
	if player:
		# Update any visual elements based on the player's position if needed
		pass
	else:
		print("Player reference is null in EyeballView.")
