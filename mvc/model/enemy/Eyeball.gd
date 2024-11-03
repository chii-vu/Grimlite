extends Area2D
class_name Eyeball

@export var speed: float = 100.0
var player: Player  # Reference to the player node

func set_player(player_ref: Player) -> void:
	# Store a reference to the player node
	player = player_ref

func _process(delta: float) -> void:
	if player:
		# Continuously move toward the player’s current position
		var direction = (player.position - position).normalized()
		position += direction * speed * delta
