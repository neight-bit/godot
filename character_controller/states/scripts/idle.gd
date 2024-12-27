extends State

@export
var fall_state: State

@export 
var move_state: State

@export
var jump_state: State

@export
var dash_state: State

@export
var climb_state: State

func enter() -> void:
	super()
	actor.velocity.x = 0
	mediator.request("reset_jumps")

func process_input(event: InputEvent) -> State:
	if mediator.request("get_jump") and actor.is_on_floor():
		return jump_state
	if mediator.request("get_dash"):
		return dash_state
	if mediator.request("get_movement_direction") != 0.0:
		return move_state
	if mediator.request("get_climb"):
		return climb_state

	return null

func process_physics(delta: float) -> State:
	actor.velocity.y += mediator.request("get_gravity") * delta
	actor.move_and_slide()

	if !actor.is_on_floor():
		return fall_state

	return null
