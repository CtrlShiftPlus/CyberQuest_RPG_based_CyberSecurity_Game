extends Node2D

@onready var enter_zone = $"../EnterZone"
@onready var prompts = [
	$"../EnterPrompt",
	$"../EnterPrompt2",
	$"../EnterPrompt3",
	$"../EnterPrompt4",
	$"../EnterPrompt5"
]

var player_inside: bool = false
var current_prompt_index: int = -1

# ── Set this to the folder where you put your cyberquest/ files ───────────
# Windows example: "file:///C:/Users/YourName/Desktop/cyberquest/"
# Mac example:     "file:///Users/YourName/Desktop/cyberquest/"
# Linux example:   "file:///home/yourname/Desktop/cyberquest/"
const TERMINAL_FOLDER = "file:///D:/College/Hackathon/Sandbox/HackRooms/files/"

const ROOM_URLS = [
	TERMINAL_FOLDER + "room0.html",   # 🔍 Intro to Ethical Hacking
	TERMINAL_FOLDER + "room1.html",   # 🐧 Linux Fundamentals
	TERMINAL_FOLDER + "room2.html",   # 🌐 Network Exploitation
	TERMINAL_FOLDER + "room3.html",   # 🌍 Web Hacking 101
	TERMINAL_FOLDER + "room4.html",   # ⚠️ Privilege Escalation
]

const ROOM_INSTRUCTIONS = [
	"🔍 Intro to Ethical Hacking\nLearn recon basics!\nPress ENTER to launch terminal.",
	"🐧 Linux Fundamentals\nMaster the filesystem!\nPress ENTER to launch terminal.",
	"🌐 Network Exploitation\nScan and exploit services!\nPress ENTER to launch terminal.",
	"🌍 Web Hacking 101\nFind web vulnerabilities!\nPress ENTER to launch terminal.",
	"⚠️ Privilege Escalation\nEscalate to root!\nPress ENTER to launch terminal.",
]

func _ready() -> void:
	print("BuildingManager ready!")
	for p in prompts:
		p.visible = false
	if enter_zone:
		enter_zone.body_entered.connect(_on_body_entered)
		enter_zone.body_exited.connect(_on_body_exited)
		print("✅ EnterZone signals connected")
	else:
		print("❌ EnterZone not found!")

func _on_body_entered(body: Node) -> void:
	print("Body entered zone: ", body.name, " groups: ", body.get_groups())
	if body.is_in_group("player"):
		player_inside = true
		_show_nearest_prompt(body.global_position)

func _on_body_exited(body: Node) -> void:
	if body.is_in_group("player"):
		player_inside = false
		current_prompt_index = -1
		for p in prompts:
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
		if shapes[i] == null:
			continue
		var d = shapes[i].global_position.distance_to(player_pos)
		if d < closest_dist:
			closest_dist = d
			closest_idx = i
	current_prompt_index = closest_idx
	for i in range(prompts.size()):
		prompts[i].visible = (i == current_prompt_index)
	print("Showing prompt index: ", current_prompt_index)

func _process(_delta: float) -> void:
	if player_inside and Input.is_action_just_pressed("ui_accept"):
		open_room()

func open_room() -> void:
	if current_prompt_index < 0:
		return
	var url = ROOM_URLS[current_prompt_index]
	print("Launching terminal: ", url)
	var err = OS.shell_open(url)
	if err == OK:
		print("✅ Terminal opened: ", url)
	else:
		print("❌ Failed to open, error: ", err)
