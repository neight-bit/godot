extends State

@export
var fall_state: State

@export 
var move_state: State

@export
var idle_state: State

@export
var dash_state: State

@export
var climb_state: State

var initial_horizontal_velocity: float

func enter() -> void:
	super()
	initial_horizontal_velocity = actor.velocity.x
	actor.velocity.y = mediator.request("get_jump_velocity")
	mediator.request("decrement_remaining_jumps", [1])
	
func process_input(_event: InputEvent) -> State:
	if mediator.request("get_dash"):
		return dash_state
	if mediator.request("get_jump"):
		return self
	if mediator.request("get_climb"):
		return climb_state
	return null

func process_physics(delta: float) -> State:
	actor.velocity.y += mediator.request("get_gravity") * delta
	if actor.velocity.y > 0:
		return fall_state
	
	var movement_direction = mediator.request("get_movement_direction")
	mediator.request("set_orientation", [movement_direction])
	actor.velocity.x = mediator.request("get_airborne_velocity", [delta, initial_horizontal_velocity])
	actor.move_and_slide()

	return null
