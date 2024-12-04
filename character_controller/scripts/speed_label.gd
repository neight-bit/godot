extends Label

@export var character: CharacterBody2D

func _process(delta: float) -> void:
	if character:
		var acceleration = character.get('acceleration')
		text = 'speed: ' + str(character.velocity) + '\n' + 'acceleration: ' + str(acceleration)
