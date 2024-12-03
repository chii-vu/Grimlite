# EnemySpawnerSystem.gd
extends Node
class_name EnemySpawnerSystem

## CONTAINS ENEMY LOGIC & SPAWNING ##

# Enemy logic

# Enemy spawning
@export var enemy_prefab: PackedScene  # Prefab for spawning enemies
@export var spawn_interval: float = 2.0  # Interval in seconds between spawns
@export var max_enemies: int = 10  # Maximum number of active enemies

@onready var random = RandomNumberGenerator.new()
var spawn_timer: float = 0.0
var player: Player  # Reference to the player node

#######################
## ENEMY LOGIC BLOCK ##
#######################

func _physics_process(delta: float) -> void:
	# make homing enemies go towards player
	for nd in get_tree().get_nodes_in_group("homing enemy"):
		nd.velocity = (player.position - nd.position).normalized() * nd.speed

##########################
## ENEMY SPAWNING BLOCK ##
##########################

func _process(delta: float) -> void:
	spawn_timer += delta
	if spawn_timer >= spawn_interval:
		spawn_timer = 0
		if get_active_enemy_count() < max_enemies:
			_spawn_enemy()

func set_player(player_ref: Player) -> void:
	# Update the reference to the player
	player = player_ref
	if !player:
		print("Error: Player reference is null in set_player.")

func get_active_enemy_count() -> int:
	# Count enemies in the scene by checking the group
	return get_tree().get_nodes_in_group("enemies").size()

func _spawn_enemy() -> void:
	if enemy_prefab == null:
		print("Error: enemy_prefab is not set. Check Inspector settings.")
		return
	
	var new_enemy = enemy_prefab.instantiate() as Eyeball
	if new_enemy == null:
		print("Error: Failed to instantiate enemy from prefab.")
		return
	
	# Set a random spawn position outside the player's view
	new_enemy.position = _get_random_spawn_position()

	# Add the enemy to the scene tree and to a group for management
	get_parent().add_child(new_enemy)
	new_enemy.add_to_group("enemies")
	new_enemy.add_to_group("homing enemy")
	
	# Now that the enemy is in the scene tree, set the player's reference
	if new_enemy.has_method("set_player"):
		new_enemy.set_player(player)

func _get_random_spawn_position() -> Vector2:
	# Generate a random position around the edges of the viewport
	var viewport_size = get_viewport().get_visible_rect().size
	var spawn_position = Vector2()

	# Randomly choose a position along the edge of the screen
	var edge = random.randi_range(0, 3)
	match edge:
		0:
			# Top edge
			spawn_position.x = random.randf_range(0, viewport_size.x)
			spawn_position.y = -50
		1:
			# Bottom edge
			spawn_position.x = random.randf_range(0, viewport_size.x)
			spawn_position.y = viewport_size.y - 50
		2:
			# Left edge
			spawn_position.x = -50
			spawn_position.y = random.randf_range(0, viewport_size.y)
		3:
			# Right edge
			spawn_position.x = viewport_size.x - 50
			spawn_position.y = random.randf_range(0, viewport_size.y)

	return spawn_position
