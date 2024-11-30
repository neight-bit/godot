extends Control

func set_score(new_score):
	$Panel/Score.text = "SCORE: " + str(new_score)

func _on_retry_button_pressed() -> void:
	get_tree().reload_current_scene()
	
func align():
	anchor_left = 0.5
	anchor_top = 0.5
	anchor_right = 0.5
	anchor_bottom = 0.5
