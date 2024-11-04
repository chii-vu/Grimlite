# Game.gd
extends Node
class_name Game

@onready var player: Player = $Player  # Reference to the Player node
@onready var enemy_spawner: EnemySpawnerSystem = $EnemySpawnerSystem  # Reference to the enemy spawner
@onready var player_anims = $Player/PlayerView

@export var player_speed: float = 200.0  # Player movement speed
var attack_timer: float = 0.0
@export var attack_interval: float = 1.5  # Time interval between auto-attacks

func _ready() -> void:
	# Set player reference in the enemy spawner system
	if enemy_spawner:
		print("EnemySpawner found. Setting player reference.")
		enemy_spawner.set_player(player)
	else:
		print("Error: EnemySpawner not found. Check the node path.")
	
	if player:
		print("Player is ready with position:", player.position)
	else:
		print("Error: Player node not found.")

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
		player_anims.move_left()
	if Input.is_action_pressed("ui_right"):
		movement.x += 1
		player_anims.move_right()


	# Normalize movement and apply speed
	movement = movement.normalized() * player_speed * delta
	if player:
		player.position += movement
	else:
		print("Error: Player reference is missing in _handle_movement.")

func _handle_auto_attack(delta: float) -> void:
	# Automatic attack logic
	attack_timer += delta
	if attack_timer >= attack_interval:
		attack_timer = 0
		_auto_attack()

func _auto_attack() -> void:
	print("Automatic attack triggered")
	# Implement auto-attack logic, e.g., creating an attack area
