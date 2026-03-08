extends CharacterBody2D

signal died(exp: int)

enum State {
	IDLE,
	CHASE,
	RETURN,
	ATTACK,
	DEAD
}

@export_category("Stats")
@export var speed: int = 128
@export var attack_damage: int = 10
@export var attack_speed: float = 1.0
@export var hitpoints: int = 180
@export var aggro_range: float = 256.0
@export var attack_range: float = 80.0

@export_category("Related Scenes")
@export var death_packed: PackedScene
@export var exp_reward: int = 600

var state: State = State.IDLE
var question_asked: bool = false
var waiting_for_question: bool = false
var has_been_questioned: bool = false

@onready var spawn_point: Vector2 = global_position
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var animation_playback: AnimationNodeStateMachinePlayback = $AnimationTree["parameters/playback"]
@onready var player: CharacterBody2D = get_tree().get_first_node_in_group("player")
@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D

func _ready() -> void:
	animation_tree.set_active(true)

func _physics_process(_delta: float) -> void:
	if state == State.DEAD:
		return
	if waiting_for_question:
		return
	if not is_instance_valid(player):
		return

	var dist = distance_to_player()

	if dist <= attack_range:
		if state != State.ATTACK:
			state = State.ATTACK
			update_animation()
		attack()
		return
	elif dist <= aggro_range:
		state = State.CHASE
		move()
	elif dist > aggro_range and global_position.distance_to(spawn_point) > 32:
		state = State.RETURN
		move()
	elif state != State.IDLE:
		state = State.IDLE
		update_animation()

func distance_to_player() -> float:
	if not is_instance_valid(player):
		return INF
	return global_position.distance_to(player.global_position)

func move() -> void:
	if state == State.CHASE:
		if not is_instance_valid(player):
			velocity = Vector2.ZERO
			move_and_slide()
			return
		nav_agent.target_position = player.global_position
	elif state == State.RETURN:
		nav_agent.target_position = spawn_point

	if nav_agent.is_navigation_finished():
		velocity = Vector2.ZERO
		move_and_slide()
		return

	var next_path_position = nav_agent.get_next_path_position()
	var direction = (next_path_position - global_position).normalized()
	velocity = direction * speed
	move_and_slide()

	if velocity.x < -0.01:
		$Sprite2D.flip_h = true
	elif velocity.x > 0.01:
		$Sprite2D.flip_h = false

	update_animation()

func _on_navigation_agent_2d_velocity_computed(safe_velocity: Vector2) -> void:
	nav_agent.velocity = safe_velocity

func update_animation() -> void:
	match state:
		State.IDLE:
			animation_playback.travel("idle")
		State.CHASE, State.RETURN:
			animation_playback.travel("run")
		State.ATTACK:
			animation_playback.travel("attack")

func attack() -> void:
	if question_asked or has_been_questioned:
		# Enemy already asked question, attack normally
		state = State.CHASE
		return

	# Only ask question once
	question_asked = true
	waiting_for_question = true
	state = State.ATTACK

	if is_instance_valid(player):
		var attack_dir = (player.global_position - global_position).normalized()
		$Sprite2D.flip_h = attack_dir.x < 0
		animation_tree.set("parameters/attack/BlendSpace2D/blend_position", attack_dir)

	var battle_ui = get_tree().get_first_node_in_group("battle_ui")
	if battle_ui:
		battle_ui.fetch_question(self, player)

	update_animation()

func take_damage(damage_taken: int) -> void:
	hitpoints -= damage_taken
	if hitpoints <= 0:
		death()

func death() -> void:
	state = State.DEAD
	died.emit(exp_reward)

	var ui = get_tree().get_first_node_in_group("game_ui")
	if ui:
		ui.add_score(10)

	if death_packed != null and is_instance_valid(get_parent()):
		var death_scene: Control = death_packed.instantiate()
		death_scene.position = global_position + Vector2(0, -32)
		get_parent().add_child(death_scene)

	queue_free()

func _on_hit_box_area_entered(area: Area2D) -> void:
	if is_instance_valid(area.owner):
		area.owner.take_damage(attack_damage)
