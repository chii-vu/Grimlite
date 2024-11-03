# Eyeball.gd
extends Area2D
class_name Eyeball

@export var speed: float = 100.0
var player: Player

@onready var view: EyeballView = $EyeballView  # Ensure EyeballView is a child node

func _ready() -> void:
	pass  # Initialization code if needed

func set_player(player_ref: Player) -> void:
	player = player_ref
	print("Player reference set in Eyeball:", player)

	if view:
		view.set_player(player)  # Pass the player reference to EyeballView
		print("Passing player reference to EyeballView.")
	else:
		print("Error: EyeballView not found as a child of Eyeball.")

func _process(delta: float) -> void:
	if player:
		# Continuously move toward the player’s current position
		var direction = (player.position - position).normalized()
		position += direction * speed * delta
