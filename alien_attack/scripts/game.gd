extends Node

@onready var player = $Player
@onready var hud = $UI/HUD 

var lives: int = 3
var score: int = 0


func _ready() -> void:
	hud.set_score_label(score)
	hud.lives_renderer.update_lives(lives)


func _on_enemy_de_spawner_area_entered(enemy):
	enemy.die()


func set_lives(delta_lives: int) -> void:
	lives += delta_lives
	hud.lives_renderer.update_lives(lives)
	if lives == 0:
		print("Game Over")
	player.die()


func _on_player_took_damage():
	set_lives(-1)


func _on_enemy_spawner_enemy_spawned(enemy_instance: Variant) -> void:
	enemy_instance.connect("enemy_died", _on_enemy_died)
	add_child(enemy_instance)


func _on_enemy_died():
	score += 10
	hud.set_score_label(score)
