extends CanvasLayer

# Add this node to the "game_ui" group in the Godot Inspector
# (Node tab → Groups → type "game_ui" → Add)

@onready var health_bar = $UIRoot/HealthBar

var max_health = 200
var health = 200
var score = 0

func _ready():
	health_bar.max_value = max_health
	health_bar.value = health

func damage(amount: int) -> void:
	health -= amount
	health = clamp(health, 0, max_health)
	health_bar.value = health
	print("Player HP: ", health, "/", max_health)
	if health <= 0:
		_on_player_dead()

func _on_player_dead() -> void:
	print("Player dead — game over")
	# Unpause first so game over scene loads cleanly
	get_tree().paused = false
	# Uncomment when you have a game over scene:
	# get_tree().change_scene_to_file("res://scenes/GameOver.tscn")

func add_score(amount: int) -> void:
	score += amount
	print("Score: ", score)

func get_hp() -> int:
	return health
