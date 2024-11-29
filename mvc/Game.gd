# Game.gd
extends Node
class_name Game

@onready var player: Player = $LocalPlayer  # Reference to the Player node
@onready var enemy_spawner: EnemySpawnerSystem = $EnemySpawnerSystem  # Reference to the enemy spawner
@onready var player_animation = $LocalPlayer/PlayerView
@onready var weapon_spawner: WeaponSpawnerSystem = $WeaponSpawnerSystem
var screen_size: Vector2

@export var player_speed: float = 200.0  # Player movement speed
var attack_timer: float = 0.0
@export var attack_interval: float = 1.5  # Time interval between auto-attacks
@export var player_invuln_time: float = 3.0 # Player invincibility on hit

func _ready() -> void:
	# Set player reference in the enemy spawner system
	if enemy_spawner:
		#print("EnemySpawner found. Setting player reference.")
		enemy_spawner.set_player(player)
	else:
		print("Error: EnemySpawner not found. Check the node path.")
	
	if weapon_spawner:
		#print("WeaponSpawner found. Setting player reference.")
		weapon_spawner.set_player(player)
	else:
		print("Error: WeaponSpawner not found. Check the node path.")
	
	if player:
		#print("Player is ready with position:", player.position)
		player.add_to_group("player")
		player.hit.connect(_start_player_invincibility)
		# initialize invuln timer
		#player.invuln_timer.wait_time = player_invuln_time
		#player.invuln_timer.timeout.connect(_end_player_invincibility)
	else:
		print("Error: Player node not found.")
	
	# setup screen size and update it when player resizes screen
	screen_size = get_viewport().get_visible_rect().size
	get_viewport().size_changed.connect(_get_new_screen_size)


func _get_new_screen_size() -> void:
	screen_size = get_viewport().get_visible_rect().size


func _physics_process(delta: float) -> void:
	_handle_movement(delta)

func _handle_movement(delta:float) -> void:
	if !player:
		print("Error: Player reference is missing in _handle_movement.")
	# Handle player movement based on input
	player.velocity = Vector2.ZERO
	if Input.is_action_pressed("ui_up"):
		player.velocity.y -= 1
	if Input.is_action_pressed("ui_down"):
		player.velocity.y += 1
	if Input.is_action_pressed("ui_left"):
		player.velocity.x -= 1
		player_animation.move_left()
	if Input.is_action_pressed("ui_right"):
		player.velocity.x += 1
		player_animation.move_right()
		
	if player.velocity != Vector2.ZERO:
		player.direction = player.velocity
	
	# Normalize movement and apply speed
	player.velocity = player.velocity.normalized() * player_speed
	player.move_and_collide(player.velocity * delta)
	
	if player.ishit:
		player.ishit = false
		print("player collide")
		_start_player_invincibility()
	
	## could maybe be done a bit better
	var player_size = Vector2(76, 114)
	
	# clamp player position within screen
	player.position = player.position.clamp(-0.5*(screen_size - player_size), 0.5*(screen_size - player_size))
	
	

func _start_player_invincibility() -> void:
	# stop player from colliding w/ enemies
	# player.set_collision_layer_value(1, false)
	player.set_collision_mask_value(2, false)
	
	# decrease score
	Hud._dec_score()
	print("player hit!")
	
	
	# start timer to end invincibility
	var timer = Timer.new()
	player.add_child(timer)
	timer.timeout.connect(_end_player_invincibility.bind(timer))
	timer.start(player_invuln_time)
	return

func _end_player_invincibility(timer:Timer) -> void:
	# make player collidable w/ enemies again
	# player.set_collision_layer_value(1, true)
	player.set_collision_mask_value(2, false)
	player.remove_child(timer)
	timer.queue_free()
	return
