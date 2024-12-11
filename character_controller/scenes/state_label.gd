extends Label

var character: CharacterBody2D

func _process(delta: float) -> void:
	if character:
		#text = 'state: ' + str(character.state_machine.current_state.name) + '\norientation: ' + str(character.orientation)
		text = "jumps left: " + str(character.remaining_jumps)
