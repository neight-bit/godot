extends Node2D

@onready var timer = $Timer
@onready var spawn_position = $SpawnPositions
var enemy_scene = preload("res://scenes/enemy.tscn")


func _ready():
	timer.connect("timeout", _on_timer_timeout)

func _on_timer_timeout():
	spawn_enemy()

func spawn_enemy():
	var positions: Array = spawn_position.get_children()
	var rand_position = positions.pick_random()
	var enemy_instance = enemy_scene.instantiate()
	enemy_instance.global_position = rand_position.global_position
	add_child(enemy_instance)
