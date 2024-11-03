extends Node
class_name EnemySpawnerSystem

@export var enemy_prefab: PackedScene  # Prefab for spawning enemies
@export var spawn_interval: float = 2.0  # Interval in seconds between spawns
@export var max_enemies: int = 10  # Maximum number of active enemies

@onready var random = RandomNumberGenerator.new()
var spawn_timer: float = 0.0
var player: Player  # Reference to the player node

func _process(delta: float) -> void:
	spawn_timer += delta
	if spawn_timer >= spawn_interval:
		spawn_timer = 0
		if get_active_enemy_count() < max_enemies:
			_spawn_enemy()

func set_player(player_ref: Player) -> void:
	# Update the reference to the player
	player = player_ref
	print("Player reference set in EnemySpawnerSystem:", player)

func get_active_enemy_count() -> int:
	# Count enemies in the scene by checking the group
	return get_tree().get_nodes_in_group("enemies").size()

func _spawn_enemy() -> void:
	# Spawn an enemy instance from the prefab
	if enemy_prefab == null:
		print("Error: enemy_prefab is not set. Check Inspector settings.")
		return

	var new_enemy = enemy_prefab.instantiate() as Area2D
	if new_enemy == null:
		print("Error: Failed to instantiate enemy from prefab.")
		return

	# Set the player's reference for the enemy
	if new_enemy.has_method("set_player"):
		new_enemy.set_player(player)
		print("Player reference passed to new enemy:", player)
	else:
		print("New enemy does not have set_player method.")

	# Set a random spawn position outside the player's view
	new_enemy.position = _get_random_spawn_position()

	# Add the enemy to the scene tree and to a group for management
	get_parent().add_child(new_enemy)
	new_enemy.add_to_group("enemies")

func _get_random_spawn_position() -> Vector2:
	# Generate a random position around the edges of the viewport
	var screen_bounds = get_viewport().get_visible_rect().size / 2.0
	var spawn_position = Vector2()

	# Randomly choose a position along the edge of the screen
	if random.randi_range(0, 1) == 0:
		spawn_position.x = random.randf_range(-screen_bounds.x, screen_bounds.x)
		spawn_position.y = screen_bounds.y if random.randi_range(0, 1) == 0 else -screen_bounds.y
	else:
		spawn_position.y = random.randf_range(-screen_bounds.y, screen_bounds.y)
		spawn_position.x = screen_bounds.x if random.randi_range(0, 1) == 0 else -screen_bounds.x

	return spawn_position
