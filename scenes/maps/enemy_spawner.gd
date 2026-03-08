extends Node2D

@export var enemy_scene: PackedScene
@export var max_enemies: int = 5

var spawn_points = []

func _ready():
	print("Spawner running")

	spawn_points = get_children()
	print("Spawn points:", spawn_points.size())

	spawn_initial_enemies()


func spawn_initial_enemies():
	for i in range(max_enemies):
		spawn_enemy()


func spawn_enemy():
	if enemy_scene == null:
		print("Enemy scene NOT assigned")
		return

	var enemy = enemy_scene.instantiate()

	var spawn = spawn_points.pick_random()

	print("Spawning enemy at:", spawn.global_position)

	enemy.position = spawn.position

	add_child(enemy)
