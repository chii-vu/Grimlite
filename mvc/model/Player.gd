# Player.gd
extends CharacterBody2D
class_name Player

@export var speed: float = 200.0
@export var health: float = 1.0  # Player health, adjust as needed
var dead: bool = false  # Player status
var hori_direction: int = 1 # -1: left, 1: right
var direction: Vector2 = Vector2(0, 0)

func _ready() -> void:
	print("Player is ready.")

func _process(delta: float) -> void:
	pass  # Update player properties if needed
