extends Label

var character: CharacterBody2D

func _process(delta: float) -> void:
	if character:
		text = 'orientation: ' + str(character.orientation)
