extends CharacterBody2D


enum State{
	IDLE,
	RUN,
	ATTACK,
	DEAD
}

@export_category("Stats")
@export var speed: int = 400
@export var attack_speed: float = 0.6
@export var attack_damage: int =60
@export var hitpoints :int =150
@export var death_packed: PackedScene 

var state: State = State.IDLE
var move_direction: Vector2=Vector2(0,0)

@onready var animation_tree:AnimationTree=$AnimationTree
@onready var animation_playback:AnimationNodeStateMachinePlayback=$AnimationTree["parameters/playback"]

func _physics_process(delta: float) -> void:
	if not state==State.ATTACK:
		movement_loop()
	
func _ready() -> void:
	animation_tree.set_active(true)
	print("Connecting hitbox signal")
	
	
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index==MOUSE_BUTTON_LEFT and event.pressed:
		attack()
	
func movement_loop() -> void:
	move_direction.x=int(Input.is_action_pressed("right")) - int(Input.is_action_pressed("left"))
	move_direction.y=int(Input.is_action_pressed("up")) - int(Input.is_action_pressed("down"))
	var motion:Vector2=move_direction.normalized()*speed
	set_velocity(motion)
	move_and_slide()
	
	if state==State.IDLE or State.RUN:
		if move_direction.x<-0.01:
			$Sprite2D.flip_h=true
		elif move_direction.x>0.01:
			$Sprite2D.flip_h=false
	
	if motion!=Vector2.ZERO and state==State.IDLE:
		state=State.RUN
		update_animation()
		
	elif motion==Vector2.ZERO and state==State.RUN:
		state=State.IDLE
		update_animation()
		
func update_animation()->void:
	match state:
		State.IDLE:
			animation_playback.travel("idle")
		State.RUN:
			animation_playback.travel("run")
		State.ATTACK:
			animation_playback.travel("attack")
			
func attack()->void:
	if state==State.ATTACK:
		return
	state=State.ATTACK
	
	var mouse_pos:Vector2=get_global_mouse_position()
	var attack_dir:Vector2= (mouse_pos -global_position).normalized()
	$Sprite2D.flip_h=attack_dir.x<0 and abs(attack_dir.x)>=abs(attack_dir.y)
	animation_tree.set("parameters/attack/BlendSpace2D/blend_position",attack_dir)
	update_animation()
	
	await get_tree().create_timer(attack_speed).timeout
	state=State.IDLE


func take_damage(damage: int) -> void:
	var ui = get_tree().get_first_node_in_group("game_ui")
	if ui:
		ui.damage(damage)
		
		
func death()->void:
	if death_packed == null:
		print("Error: death_packed scene not assigned.")
		queue_free()
		return
	var death_scene: Node2D = death_packed.instantiate()        
	death_scene.position = global_position + Vector2(0.0,-32.0)
	%Effects.add_child(death_scene)                                                
	queue_free()


func _on_hit_box_area_entered(area: Area2D) -> void:
	print("Hit detected with area:", area)
	area.owner.take_damage(attack_damage)
	
