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

@export
var fall_state: State

func enter():
	super()
	mediator.request("start_attack", ["grounded_attack"])

func process_input(event: InputEvent) -> State:
	if animation_player.is_playing():
		if not mediator.request("can_cancel_attack"):
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
	actor.velocity.y += mediator.request("get_gravity") * delta
	actor.velocity.x = mediator.request("get_grounded_velocity", [delta, true])
	actor.move_and_slide()
	
	if !actor.is_on_floor() and not mediator.request("is_dashing"):
		return fall_state
	
	if animation_player.is_playing():
		return null
	
	if mediator.request("get_movement_direction") != 0.0:
		return move_state
	
	else: return idle_state
