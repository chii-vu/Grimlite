extends Node
class_name WeaponSpawnerSystem

@export var hammer_prefab: PackedScene # prefab for 
@export var hammer_interval: float = 1.0 # interval in seconds between attacks
@export var max_hammer: int = 5 # Max # of active hammer 

var spawn_timer: float = 0.0
var player: Player # Ref to the player node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func set_player(player_ref: Player) -> void
