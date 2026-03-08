extends Control

const NEXT_GAME  = "res://scenes/maps/Level2.tscn"
const GAME_SCENE = "res://scenes/maps/test_map.tscn"

@onready var replay_btn = $Replay
@onready var next_btn   = $NextLevel

func _ready() -> void:
	replay_btn.text = "↺  Replay"
	next_btn.text   = "▶  Next Level"
	replay_btn.pressed.connect(_on_replay)
	next_btn.pressed.connect(_on_next_level_pressed)

func _on_replay() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file(GAME_SCENE)

func _on_next_level_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file(NEXT_GAME)
