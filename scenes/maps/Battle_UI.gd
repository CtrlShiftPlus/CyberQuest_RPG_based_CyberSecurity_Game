extends CanvasLayer

@onready var question_label = $Panel/VBoxContainer/QuestionLabel
@onready var btn_a = $Panel/VBoxContainer/ButtonA
@onready var btn_b = $Panel/VBoxContainer/ButtonB
@onready var btn_c = $Panel/VBoxContainer/ButtonC
@onready var btn_d = $Panel/VBoxContainer/ButtonD

var all_questions = []
var remaining_questions = []
var current_question = null
var current_enemy = null
var current_player = null
var questions_answered = 0
var _answer_locked = false

const TOTAL_QUESTIONS = 20
const NEXT_LEVEL = "res://scenes/Level2.tscn"

func _ready() -> void:
	visible = false
	load_questions()
	btn_a.pressed.connect(func(): check_answer(0))
	btn_b.pressed.connect(func(): check_answer(1))
	btn_c.pressed.connect(func(): check_answer(2))
	btn_d.pressed.connect(func(): check_answer(3))

func load_questions() -> void:
	var file = FileAccess.open("res://questions.json", FileAccess.READ)
	if file == null:
		print("ERROR: questions.json not found!")
		return
	var text = file.get_as_text()
	file.close()
	var data = JSON.parse_string(text)
	if data == null:
		print("ERROR: Failed to parse questions.json!")
		return
	all_questions = data
	reset_question_pool()
	print("Loaded ", all_questions.size(), " questions")

func reset_question_pool() -> void:
	remaining_questions = all_questions.duplicate()
	remaining_questions.shuffle()

func fetch_question(enemy, player) -> void:
	current_enemy  = enemy
	current_player = player
	_answer_locked = false
	visible = true
	get_tree().paused = true
	show_next_question()

func close() -> void:
	visible = false
	get_tree().paused = false
	_answer_locked = false

func show_next_question() -> void:
	if remaining_questions.size() == 0:
		reset_question_pool()
	current_question    = remaining_questions.pop_front()
	question_label.text = current_question["question"]
	btn_a.text = current_question["options"][0]
	btn_b.text = current_question["options"][1]
	btn_c.text = current_question["options"][2]
	btn_d.text = current_question["options"][3]
	_answer_locked = false

func check_answer(index: int) -> void:
	if current_question == null or _answer_locked:
		return
	_answer_locked = true

	var correct_index = current_question["answer_index"]
	questions_answered += 1

	if index == correct_index:
		print("✅ Correct!")
		var ui = get_tree().get_first_node_in_group("game_ui")
		if ui and ui.has_method("add_score"):
			ui.add_score(10)
		_resolve_correct()
	else:
		print("❌ Wrong! Correct: ", current_question["options"][correct_index])
		_resolve_wrong()

	if questions_answered >= TOTAL_QUESTIONS:
		await get_tree().process_frame
		go_to_next_round()

func _resolve_correct() -> void:
	var dmg = 0
	if is_instance_valid(current_player):
		dmg = current_player.attack_damage

	# Mark enemy as questioned so attack() never opens UI again
	if is_instance_valid(current_enemy):
		current_enemy.question_asked       = false
		current_enemy.waiting_for_question = false
		current_enemy.has_been_questioned  = true

	var enemy_ref = current_enemy
	end_battle()   # unpause first

	# Damage after unpause
	if is_instance_valid(enemy_ref):
		enemy_ref.take_damage(dmg)

func _resolve_wrong() -> void:
	if is_instance_valid(current_enemy):
		current_enemy.question_asked       = false
		current_enemy.waiting_for_question = false
		current_enemy.has_been_questioned  = true
		current_enemy.state                = current_enemy.State.CHASE

	end_battle()   # unpause first

	# Damage player after unpause
	await get_tree().process_frame
	var ui = get_tree().get_first_node_in_group("game_ui")
	if ui and ui.has_method("damage"):
		ui.damage(1)

func end_battle() -> void:
	visible           = false
	get_tree().paused = false
	current_question  = null
	_answer_locked    = false
	if is_instance_valid(current_enemy):
		current_enemy.waiting_for_question = false
		current_enemy.question_asked = false
	current_enemy     = null
	current_player    = null

func go_to_next_round() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file(NEXT_LEVEL)
