extends Node
class_name Game

@onready var player: Player = $Player  # Reference to the Player node
@onready var enemy_spawner: EnemySpawnerSystem = $EnemySpawnerSystem  # Reference to the enemy spawner
@export var player_speed: float = 200.0  # Speed of player movement
@export var attack_interval: float = 1.5  # Interval for automatic attacks

var attack_timer: float = 0.0

func _ready() -> void:
	# Check if enemy_spawner is properly initialized
	if enemy_spawner == null:
		print("Error: EnemySpawner not found. Check the node path.")
	else:
		print("EnemySpawner initialized successfully.")

func _process(delta: float) -> void:
	# Handle player movement
	var movement = Vector2.ZERO
	if Input.is_action_pressed("ui_up"):
		movement.y -= 1
	if Input.is_action_pressed("ui_down"):
		movement.y += 1
	if Input.is_action_pressed("ui_left"):
		movement.x -= 1
	if Input.is_action_pressed("ui_right"):
		movement.x += 1

	# Normalize movement and apply player speed
	movement = movement.normalized() * player_speed * delta
	player.position += movement

	# Update the enemy spawner with the player’s position if it's available
	if enemy_spawner != null:
		enemy_spawner.player_position = player.position

	# Auto-attack logic
	attack_timer += delta
	if attack_timer >= attack_interval:
		attack_timer = 0.0
		_auto_attack()

func _auto_attack() -> void:
	print("Automatic attack triggered")
	# Implement auto-attack logic here, such as creating a damage area or applying an effect to nearby enemies
