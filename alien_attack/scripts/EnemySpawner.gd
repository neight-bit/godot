extends Node2D

@onready var spawn_position = $SpawnPositions
var enemy_scene = preload("res://scenes/enemy.tscn")

signal enemy_spawned(enemy_instance)

func _ready() -> void:
	generate_timer()


func generate_timer():
	var timer = get_tree().create_timer(randi_range(1, 10)*.5)
	print('[generate_timer] ' + str(timer.time_left) + ' seconds')
	timer.connect("timeout", _on_timer_timeout)


func _on_timer_timeout():
	spawn_enemy()
	generate_timer()


func spawn_enemy():
	var positions: Array = spawn_position.get_children()
	var rand_position = positions.pick_random()
	var enemy_instance = enemy_scene.instantiate()
	enemy_instance.global_position = rand_position.global_position
	#add_child(enemy_instance)
	emit_signal("enemy_spawned", enemy_instance)
