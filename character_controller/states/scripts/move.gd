extends State

@export
var fall_state: State

@export
var idle_state: State

@export
var jump_state: State

@export
var dash_state: State

func enter() -> void:
	super()
	mediator.request("reset_jumps")

func process_input(_event: InputEvent) -> State:
	if mediator.request("get_jump"):
		return jump_state
	if mediator.request("get_dash"):
		return dash_state
	return null

func process_physics(delta: float) -> State:
	actor.velocity.y += mediator.request("get_gravity") * delta

	var move_direction = mediator.request("get_movement_direction")
	mediator.request("set_orientation", [move_direction])
	if actor.velocity.x == 0 and move_direction == 0:
		return idle_state

	actor.velocity.x = mediator.request("get_grounded_velocity", [delta])
	actor.move_and_slide()

	if !actor.is_on_floor() and not mediator.request("is_dashing"):
		mediator.request("start_coyote_time")
		return fall_state

	return null
