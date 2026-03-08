extends Control

const DOCS_URL   = "https://owasp.org"
const GAME_SCENE = "res://scenes/maps/test_map.tscn"
const SAVE_FILE  = "user://savegame.dat"


@onready var start_btn   = $VBoxContainer/StartButton
@onready var resume_btn  = $VBoxContainer/ResumeButton
@onready var docs_btn    = $VBoxContainer/DocsButton

func _ready() -> void:

	start_btn.text  = "▶  Start Game"
	resume_btn.text = "↺  Resume"
	docs_btn.text   = "Resources for Learning"

	resume_btn.visible = FileAccess.file_exists(SAVE_FILE)

	start_btn.pressed.connect(_on_start)
	resume_btn.pressed.connect(_on_resume)
	docs_btn.pressed.connect(_on_docs)

func _on_start() -> void:
	get_tree().change_scene_to_file(GAME_SCENE)

func _on_resume() -> void:
	get_tree().change_scene_to_file(GAME_SCENE)

func _on_docs() -> void:
	OS.shell_open(DOCS_URL)
