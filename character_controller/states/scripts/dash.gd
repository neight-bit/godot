extends State

@export
var idle_state: State

@export
var move_state: State

@export
var jump_state: State

@export
var fall_state: State

func enter() -> void:
	super()
	mediator.request("start_dashing")

func exit() -> void:
	mediator.request("stop_dashing")

func process_input(event: InputEvent) -> State:
	if mediator.request("get_jump"):
		return jump_state
	return null

func process_physics(delta: float) -> State:
	if not mediator.request("is_dashing"):
		if actor.velocity.y > 0:
			return fall_state
		if mediator.request("get_movement_direction") != 0.0:
			return move_state
		return idle_state
	
	actor.velocity.y = 0
	actor.velocity.x = mediator.request("get_dash_velocity")
	actor.move_and_slide()
	
	return null
