extends State

@export
var fall_state: State

@export
var idle_state: State

@export
var jump_state: State

@export
var dash_state: State

func _init() -> void:
	required_components = ["jump_component"]
	optional_components = ["dash_component"]

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

	var move_direction =mediator.request("get_movement_direction")
	actor.orientation = move_direction
	if actor.velocity.x == 0 and move_direction == 0:
		return idle_state

	actor.velocity.x = mediator.request("get_grounded_velocity", [delta])
	actor.move_and_slide()
	
	if !actor.is_on_floor() and not mediator.is_dashing:
		return fall_state

	return null
