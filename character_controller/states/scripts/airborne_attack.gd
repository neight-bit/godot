extends Airborne

@export
var move_state: State

@export
var idle_state: State

func enter():
	super()

func process_input(event: InputEvent) -> State:
	"""This is basically just a placeholder in case we want to add something later.
	I'm not sure that we need to process any input at all... just play the animation and immediately transition."""
	if animation_player.is_playing():
		return null
	return null
	
func process_physics(delta: float) -> State:
	super(delta)
	if actor.is_on_floor():
		if mediator.request("get_movement_direction") != 0.0:
			return move_state
		else:
			return idle_state
			
	if animation_player.is_playing():
		return null
	
	if !mediator.request("is_dashing"):
		return fall_state

	return null
