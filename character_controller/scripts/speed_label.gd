extends Label

@export var character: CharacterBody2D

func _process(delta: float) -> void:
	if character:
		text = 'speed: ' + str(character.velocity)
