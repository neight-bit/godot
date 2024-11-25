extends Node

@onready var player = $Player

var lives = 3
var score = 0

func _on_enemy_de_spawner_area_entered(enemy):
	enemy.die()

func _on_player_took_damage():
	lives-=1
	if lives == 0:
		print("Game Over")
		player.die()


func _on_enemy_enemy_died():
	score +=10
