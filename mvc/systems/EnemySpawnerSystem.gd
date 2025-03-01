# EnemySpawnerSystem.gd
extends Node
class_name EnemySpawnerSystem

## CONTAINS ENEMY LOGIC & SPAWNING ##

# Enemy logic

# Enemy spawning
@export var enemy_prefab: PackedScene  # Prefab for spawning enemies
@export var cat_scene = preload("res://mvc/model/enemy/cat.tscn")
@export var spawn_interval: float = 2.0  # Interval in seconds between spawns
@export var max_enemies: int = 3  # Maximum number of active enemies

@onready var random = RandomNumberGenerator.new()
var spawn_timer: float = 0.0
var player: Player  # Reference to the player node

var difficulty_scaler: float = 0.5

var difficulty_scaling_const: float = 0.05

#######################
## ENEMY LOGIC BLOCK ##
#######################

func _physics_process(delta: float) -> void:
	# make homing enemies go towards player
	for nd in get_tree().get_nodes_in_group("homing enemy"):
		nd.velocity = (player.position - nd.position).normalized() * nd.speed * difficulty_scaler

##########################
## ENEMY SPAWNING BLOCK ##
##########################

func _process(delta: float) -> void:
	spawn_timer += delta
	if spawn_timer >= spawn_interval / difficulty_scaler:
		difficulty_scaler += difficulty_scaling_const
		spawn_timer = 0
		if get_active_enemy_count() < max_enemies * difficulty_scaler:
			_spawn_enemy()
			_spawn_cat()
			

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
	var camera = get_viewport().get_camera_2d()
	var spawn_position = Vector2()

	if camera:
		# Get the visible rectangle of the camera
		var viewport_rect = Rect2(
			camera.global_position - (camera.zoom * get_viewport().get_visible_rect().size / 2),
			camera.zoom * get_viewport().get_visible_rect().size
		)

		var edge = random.randi_range(0, 3)
		match edge:
			0:  # Top edge
				spawn_position.x = random.randf_range(viewport_rect.position.x, viewport_rect.position.x + viewport_rect.size.x)
				spawn_position.y = viewport_rect.position.y - 100
			1:  # Bottom edge
				spawn_position.x = random.randf_range(viewport_rect.position.x, viewport_rect.position.x + viewport_rect.size.x)
				spawn_position.y = viewport_rect.position.y + viewport_rect.size.y + 100
			2:  # Left edge
				spawn_position.x = viewport_rect.position.x - 100
				spawn_position.y = random.randf_range(viewport_rect.position.y, viewport_rect.position.y + viewport_rect.size.y)
			3:  # Right edge
				spawn_position.x = viewport_rect.position.x + viewport_rect.size.x + 100
				spawn_position.y = random.randf_range(viewport_rect.position.y, viewport_rect.position.y + viewport_rect.size.y)

	return spawn_position
	
	
func _spawn_cat() -> void:
	if cat_scene == null:
		print("Error: cat_scene is not set. Check Inspector settings.")
		return
	
	var new_enemy = cat_scene.instantiate() as Cat
	if new_enemy == null:
		print("Error: Failed to instantiate enemy cat from prefab.")
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
