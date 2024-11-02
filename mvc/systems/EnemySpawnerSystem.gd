extends Node
class_name EnemySpawnerSystem

@export var EyeballPrefab: PackedScene
@export var spawn_interval: float = 2.0  # Interval between spawns
@export var max_monsters: int = 10  # Max number of monsters in the scene

@onready var random: RandomNumberGenerator = RandomNumberGenerator.new()
var spawn_timer: float = 0.0
var player_position: Vector2 = Vector2.ZERO  # Reference to the player's position

func _process(delta: float) -> void:
	spawn_timer += delta
	if spawn_timer >= spawn_interval:
		spawn_timer = 0.0
		if get_active_monster_count() < max_monsters:
			spawn_monster()

# Counts currently active monsters
func get_active_monster_count() -> int:
	return get_tree().get_nodes_in_group("monsters").size()

# Spawns a new monster
func spawn_monster() -> void:
	var new_monster = EyeballPrefab.instantiate() as Eyeball
	new_monster.player_position = player_position  # Pass player position to the monster
	new_monster.position = get_random_spawn_position()  # Set spawn location
	get_parent().add_child(new_monster)
	new_monster.add_to_group("monsters")

# Generates a random spawn position around the screen edges
func get_random_spawn_position() -> Vector2:
	var screen_bounds: Vector2 = get_viewport().get_visible_rect().size / 2.0
	var spawn_position = Vector2()
	if random.randi_range(0, 1) == 0:
		spawn_position.x = random.randf_range(-screen_bounds.x, screen_bounds.x)
		spawn_position.y = screen_bounds.y if random.randi_range(0, 1) == 0 else -screen_bounds.y
	else:
		spawn_position.y = random.randf_range(-screen_bounds.y, screen_bounds.y)
		spawn_position.x = screen_bounds.x if random.randi_range(0, 1) == 0 else -screen_bounds.x
	return spawn_position
