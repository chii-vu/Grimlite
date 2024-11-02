extends RigidBody2D
class_name Eyeball

@export var speed: float = 100.0
var player_position: Vector2 = Vector2.ZERO

func _process(delta: float) -> void:
	if player_position:
		# Calculate direction toward player and move in that direction
		var direction = (player_position - position).normalized()
		linear_velocity = direction * speed
