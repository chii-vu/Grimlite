extends CanvasLayer

var score: int = 0
var player_health: float = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _inc_score() -> void:
	score += 1
	$ScoreCounter.set_text("Score: %s\nHealth: %s" % [score, player_health])
	show()
	return

func _dec_score() -> void:
	if (score > 0):
		score -= 1
	else:
		player_health -= 1
	$ScoreCounter.set_text("Score: %s\nHealth: %s" % [score, player_health])
	show()
	return

func set_player_health(hp: float) -> void:
	player_health = hp
	$ScoreCounter.set_text("Score: %s\nHealth: %s" % [score, player_health])
	show()
