extends CanvasLayer

# ── ALL @onready vars together at the top ──
@onready var health_label: Label = $HealthLabel
@onready var score_label: Label = $ScoreLabel
@onready var room_popup = $RoomPopup
@onready var instruction_label = $RoomPopup/VBoxContainer/InstructionLabel
@onready var open_button = $RoomPopup/VBoxContainer/OpenButton
@onready var close_button = $RoomPopup/VBoxContainer/CloseButton
@onready var enter_zone = $"../EnterZone"
@onready var prompts = [
	$"../EnterPrompt",
	$"../EnterPrompt2",
	$"../EnterPrompt3",
	$"../EnterPrompt4",
	$"../EnterPrompt5"
]

# ── regular vars ──
var max_health: int = 200
var current_health: int = 200
var score: int = 0
var player_inside: bool = false
var current_prompt_index: int = -1
var _pending_url: String = ""

# ── constants ──
const GAME_OVER_SCENE = "res://scenes/game_over.tscn"
const ROOM_URLS = [
	"https://tryhackme.com/room/introtoethicalhacking",
	"https://tryhackme.com/room/linuxfundamentalspart1",
	"https://tryhackme.com/room/networkservices",
	"https://tryhackme.com/room/webhacking101",
	"https://tryhackme.com/room/privescplayground",
]
const ROOM_INSTRUCTIONS = [
	"🔍 Intro to Ethical Hacking\nLearn the basics!\nPress ENTER to open TryHackMe.",
	"🐧 Linux Fundamentals\nPractise Linux commands!\nPress ENTER to open TryHackMe.",
	"🌐 Network Exploitation\nScan and exploit!\nPress ENTER to open TryHackMe.",
	"🌍 Web Hacking\nFind vulnerabilities!\nPress ENTER to open TryHackMe.",
	"⚠️ Privilege Escalation\nEscalate to root!\nPress ENTER to open TryHackMe.",
]

# ── ready ──
func _ready() -> void:
	room_popup.visible = false
	open_button.pressed.connect(_on_open_pressed)
	close_button.pressed.connect(_on_close_pressed)
	update_health_label()
	update_score_label()

# ── health & score ──
func damage(amount: int) -> void:
	current_health -= amount
	current_health = max(0, current_health)
	update_health_label()
	if current_health <= 0:
		game_over()

func add_score(amount: int) -> void:
	score += amount
	update_score_label()

func get_hp() -> int:
	return current_health

func update_health_label() -> void:
	health_label.text = "❤️  %d / %d" % [current_health, max_health]

func update_score_label() -> void:
	score_label.text = "⭐  %d" % score

func game_over() -> void:
	get_tree().paused = false
	if get_tree() != null:
		get_tree().change_scene_to_file(GAME_OVER_SCENE)
	else:
		print("Error: SceneTree is null!")

# ── room popup ──
func show_room_popup(instructions: String, url: String) -> void:
	_pending_url = url
	instruction_label.text = instructions
	room_popup.visible = true
	get_tree().paused = true

func _on_open_pressed() -> void:
	OS.shell_open(_pending_url)
	_on_close_pressed()

func _on_close_pressed() -> void:
	room_popup.visible = false
	get_tree().paused = false

# ── enter zone prompts ──
func _on_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		player_inside = true
		_show_nearest_prompt(body.global_position)

func _on_body_exited(body: Node) -> void:
	if body.is_in_group("player"):
		player_inside = false
		current_prompt_index = -1
		for p in prompts:
			if is_instance_valid(p):
				p.visible = false

func _show_nearest_prompt(player_pos: Vector2) -> void:
	var shapes = [
		$"../EnterZone/CollisionShape2D",
		$"../EnterZone/CollisionShape2D2",
		$"../EnterZone/CollisionShape2D3",
		$"../EnterZone/CollisionShape2D4",
		$"../EnterZone/CollisionShape2D5",
	]

	var closest_dist = INF
	var closest_idx = -1

	for i in range(shapes.size()):
		if not is_instance_valid(shapes[i]):
			continue
		var d = shapes[i].global_position.distance_to(player_pos)
		if d < closest_dist:
			closest_dist = d
			closest_idx = i

	current_prompt_index = closest_idx

	for i in range(prompts.size()):
		if is_instance_valid(prompts[i]):
			prompts[i].visible = (i == current_prompt_index)

func _process(_delta: float) -> void:
	if player_inside and Input.is_action_just_pressed("ui_accept"):
		open_room()

func open_room() -> void:
	if current_prompt_index < 0:
		return
	var ui = get_tree().get_first_node_in_group("game_ui")
	if ui and ui.has_method("show_room_popup"):
		ui.show_room_popup(
			ROOM_INSTRUCTIONS[current_prompt_index],
			ROOM_URLS[current_prompt_index]
		)
