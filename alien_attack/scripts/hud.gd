extends Control

@onready var score_renderer = $Score
@onready var lives_renderer = $Lives


func set_score_label(new_score: int) -> void:
	score_renderer.text = 'SCORE: ' + str(new_score)
