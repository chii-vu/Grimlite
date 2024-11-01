extends Node
class_name Game

# This is the main 'controller' class
@onready var local_player : Player = $LocalPlayer
@onready var asteroids : Node2D = $EnemyHolderNode
@onready var bullets : Node2D = $WeaponsHolderNode
@onready var asteroid_spawner_system : EnemySpawnerSystem = $EnemySpawnerSystem

@export var PlayerWarpTime : float = 5
@export var BackwardsBulletThurst : float = 50
@export var RotationSpeed : float = 3000.0
@export var WhipPrefab : PackedScene

func _ready() -> void:
	# hookup the signal / custom callback for player hitting asteroids
	# i prefer to do this in code...
	
	# local_player.body_entered.connect(self._on_asteroid_hit_local_player)
	pass

func _physics_process(delta: float) -> void:
	# I like 'tick_game' better than physics process,
	# so just call 'tick' game
	_tick_game(delta)

func _tick_game(delta:float) -> void:
	# controller's tick method should read input, and update game state
	
	# process input
	local_player.TurningLeft = false
	local_player.TurningRight = false
	if Input.is_action_just_pressed("Shoot"):
		_shoot(local_player)
	if Input.is_key_pressed(KEY_LEFT):
		local_player.TurningLeft = true
	if Input.is_key_pressed(KEY_RIGHT):	
		local_player.TurningRight = true	
	
	# tick player logic
	# update turning state
	var rotate_amount := RotationSpeed * delta
	if local_player.TurningLeft:
		local_player.apply_torque_impulse(-rotate_amount)
	elif local_player.TurningRight:
		local_player.apply_torque_impulse(rotate_amount)
	
	# check for player warp
	_check_warp_player(local_player)
	
	# decrement warp counter, clamp to zero
	local_player.WarpCounter -= delta
	local_player.WarpCounter = max(local_player.WarpCounter, 0)
	
	# tick the asteroid spawning system
	# so the spawner system can hookup the asteroid
	# collision callback
	asteroid_spawner_system.tick(delta, asteroids, self)


func _check_warp_player(player:Player):
	
	var screen_size : Vector2 = get_viewport().get_visible_rect().size
	var bounds_rect : Rect2 = Rect2(screen_size*-0.5, screen_size)
	
	if not bounds_rect.has_point(player.position):
		print("warp")
		var new_pos := player.position
		new_pos.x = wrapf(new_pos.x, bounds_rect.position.x, bounds_rect.position.x+bounds_rect.size.x)
		new_pos.y = wrapf(new_pos.y, bounds_rect.position.y, bounds_rect.position.y+bounds_rect.size.y)
		
		# Annoyance of godot, but 'setting' hard positions of rigid bodies
		# has to be done in the rigid bodies node
		# set the position, and let that class do it
		player.TargetWarpLocation = new_pos
		player.WarpCounter = PlayerWarpTime

func _shoot(player:Player) -> void:
	print("Firing bullet, moving backwards")
	var transform := player.position
	var backwards_force := Vector2(0, 1) * BackwardsBulletThurst
	var dir := Vector2.from_angle(player.rotation+(PI/2.0))
	player.apply_central_impulse(dir * BackwardsBulletThurst)
	
	# SPAWN BULLET
	var new_bullet : Whip = WhipPrefab.instantiate() as Whip
	bullets.add_child(new_bullet)
	
	# ( pass the bullet as well )
	# the '.bind' ADDS another argument to the callback / signal handler
	# see the godot documentation on callable / bind
	# We want a callback that pass BOTH the asteroid and the bullet
	# so our controller can basically delete both nodes on collision
	var callable := Callable(self._on_bullet_hit).bind(new_bullet)
	new_bullet.body_entered.connect(callable)
	
	# Set some initial properties of the new bullet
	new_bullet.position = transform	
	new_bullet.linear_velocity = (-backwards_force*20).rotated(player.rotation)

func _on_asteroid_hit_local_player(asteroid:Node) -> void:
	print("_on_asteroid_hit_local_player")

	local_player.Health -= 0.1
	local_player.Health = max(local_player.Health, 0)
	# check if ur dead
	if local_player.Health < 0:
		# die?
		local_player.Dead = true
		local_player.RespawnCounter = 5.0

func _on_bullet_hit(hit_node:Node, bullet:Whip) -> void:
	print("_on_bullet_hit")
	if hit_node is Eyeball:
		# hit_node is an asteroid
		print("bullet hit eyeball")
		# delete both
		hit_node.queue_free()
		bullet.queue_free()
