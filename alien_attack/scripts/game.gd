extends Node

#@onready var player = $Player
@onready var hud = $UI/HUD 

var game_over_scene = preload("res://scenes/game_over_screen.tscn")
var player_scene = preload("res://scenes/player.tscn")
var lives: int = 3
var score: int = 0
var playing: bool = false


func _ready() -> void:
	hud.set_score_label(score)
	set_lives(0)
	hud.lives_renderer.update_lives(lives)
	playing = true
	start_score_timer()


func spawn_player():
	print("[ spawn_player ] ")
	if lives >= 0:
		var player = player_scene.instantiate()
		add_child(player)
		player.global_position = Vector2(50, 350)
		player.connect("took_damage", _on_player_took_damage)


func start_score_timer():
	var score_timer = Timer.new()
	score_timer.wait_time = 1.0
	score_timer.one_shot = false
	add_child(score_timer)
	score_timer.start()
	score_timer.connect("timeout", _on_score_timer_timeout)


func _on_score_timer_timeout():
	if playing:
		update_score(1)


func _on_enemy_de_spawner_area_entered(enemy):
	enemy.die("despawn")


func update_score(delta_score):
	score += delta_score
	hud.set_score_label(score)


func game_over():
	playing = false
	await get_tree().create_timer(1.5).timeout
	var game_over_instance: Control = game_over_scene.instantiate()
	game_over_instance.set_score(score)
	game_over_instance.align()
	hud.add_child(game_over_instance)


func set_lives(delta_lives: int) -> void:
	print("[ set_lives ] current lives: " + str(lives) + ", delta lives: " + str(delta_lives))
	lives += delta_lives
	hud.lives_renderer.update_lives(lives)
	if lives == 0:
		game_over()
	else:
		spawn_player()


func _on_player_took_damage(player_instance):
	print(["[ _on_player_took_damage ]"])
	player_instance.die()
	set_lives(-1)


func _on_enemy_spawner_enemy_spawned(enemy_instance: Variant) -> void:
	enemy_instance.connect("enemy_died", _on_enemy_died)
	add_child(enemy_instance)


func _on_enemy_died(death_type):
	if death_type == "despawn":
		update_score(-5)
	if death_type == "player_collision":
		pass
	else:
		update_score(10)
