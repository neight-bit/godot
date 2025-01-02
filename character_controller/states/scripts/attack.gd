extends State

@export
var idle_state: State

@export 
var move_state: State

@export
var jump_state: State

@export
var dash_state: State

@export
var climb_state: State

func enter():
	super()

func process_input(event: InputEvent) -> State:
	if animations.is_playing():
		return null
	if mediator.request("get_jump") and actor.is_on_floor():
		return jump_state
	if mediator.request("get_dash"):
		return dash_state
	if mediator.request("get_movement_direction") != 0.0:
		return move_state
	if mediator.request("get_climb"):
		return climb_state
	return idle_state

func process_physics(delta: float) -> State:
	
	# actor.velocity.x = mediator.request("get_grounded_decelerating_velocity", [delta])
	# actor.move_and_slide()
	
	if animations.is_playing():
		return null
	else: return idle_state
