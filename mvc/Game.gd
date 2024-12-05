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
@export var player_invuln_flash: float = 0.05 # invuln flash frequencing

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
		player_animation.continue_moving()
	if Input.is_action_pressed("ui_down"):
		player.velocity.y += 1
		player_animation.continue_moving()
	if Input.is_action_pressed("ui_left"):
		player.velocity.x -= 1
		player_animation.move_left()
	if Input.is_action_pressed("ui_right"):
		player.velocity.x += 1
		player_animation.move_right()
	
	if (Input.get_vector("ui_right","ui_left","ui_up","ui_down"))==Vector2.ZERO: 
		player_animation.no_input()
	
	if Input.is_action_pressed("Shoot"):
		print(Hud.score)
	
	if player.velocity != Vector2.ZERO:
		player.direction = player.velocity
	
	# Normalize movement and apply speed
	player.velocity = player.velocity.normalized() * player_speed
	player.move_and_collide(player.velocity * delta)
	
	if player.ishit:
		player.ishit = false
		print("player collide")
		player.health -= 1
		Hud.set_player_health(player.health)
		_start_player_invincibility()
	
	if player.health <= 0:
		weapon_spawner.hammer_interval = 100
		player.set_collision_layer_value(1, false)
		player.set_collision_mask_value(2, false)
		player.visible = false
		var tm = Timer.new()
		add_child(tm)
		tm.timeout.connect(_to_title_screen)
		tm.start(1.5)
	
	## could maybe be done a bit better
	var player_size = Vector2(76, 114)
	
	# clamp player position within screen
	#player.position = player.position.clamp(-0.5*(screen_size - player_size), 0.5*(screen_size - player_size))
	


func _to_title_screen():
	get_tree().change_scene_to_file("res://StartMenu.tscn")


func _start_player_invincibility() -> void:
	# stop player from colliding w/ enemies
	player.set_collision_layer_value(1, false)
	player.set_collision_mask_value(2, false)
	# decrease score
	Hud._dec_score()
	print("player hit!")
	
	var invinc_timer = Timer.new()
	player.add_child(invinc_timer)
	invinc_timer.timeout.connect(_invinc_flash)
	invinc_timer.start(player_invuln_flash)
	
	
	# start timer to end invincibility
	var timer = Timer.new()
	player.add_child(timer)
	timer.timeout.connect(_end_player_invincibility.bind(timer, invinc_timer))
	timer.start(player_invuln_time)
	return

func _end_player_invincibility(timer:Timer, invinc_timer:Timer) -> void:
	# make player collidable w/ enemies again
	player.set_collision_layer_value(1, true)
	player.set_collision_mask_value(2, true)
	player.remove_child(timer)
	player.remove_child(invinc_timer)
	invinc_timer.queue_free()
	timer.queue_free()
	player.visible = true
	return

func _invinc_flash() -> void:
	if player.visible:
		player.visible = false
	else:
		player.visible = true
