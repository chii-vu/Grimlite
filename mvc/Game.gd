extends Node
class_name Game

@onready var player: Player = $Player  # Reference to the Player node
@onready var enemy_spawner: EnemySpawnerSystem = $EnemySpawnerSystem  # Reference to the enemy spawner

@export var player_speed: float = 200.0  # Player movement speed
var attack_timer: float = 0.0
@export var attack_interval: float = 1.5  # Time interval between auto-attacks

func _ready() -> void:
	# Set player reference in the enemy spawner system
	if enemy_spawner:
		enemy_spawner.set_player(player)
	else:
		print("Error: EnemySpawner not found. Check the node path.")

func _process(delta: float) -> void:
	_handle_movement(delta)
	_handle_auto_attack(delta)

func _handle_movement(delta: float) -> void:
	# Handle player movement based on input
	var movement = Vector2.ZERO
	if Input.is_action_pressed("ui_up"):
		movement.y -= 1
	if Input.is_action_pressed("ui_down"):
		movement.y += 1
	if Input.is_action_pressed("ui_left"):
		movement.x -= 1
	if Input.is_action_pressed("ui_right"):
		movement.x += 1

	# Normalize movement and apply speed
	movement = movement.normalized() * player_speed * delta
	player.position += movement

func _handle_auto_attack(delta: float) -> void:
	# Automatic attack logic
	attack_timer += delta
	if attack_timer >= attack_interval:
		attack_timer = 0
		_auto_attack()

func _auto_attack() -> void:
	print("Automatic attack triggered")
	# Implement auto-attack logic, e.g., creating an attack area
