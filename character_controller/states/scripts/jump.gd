extends Airborne

@export 
var move_state: State

@export
var idle_state: State

@export
var dash_state: State

@export
var climb_state: State

func enter() -> void:
	super()
	actor.velocity.y = mediator.request("get_jump_velocity")
	mediator.request("decrement_remaining_jumps", [1])
	
func process_input(_event: InputEvent) -> State:
	if mediator.request("get_attack"):
		return airborne_attack_state
	if mediator.request("get_dash"):
		return dash_state
	if mediator.request("get_jump"):
		return self
	if mediator.request("get_climb"):
		return climb_state
	return null

func process_physics(delta: float) -> State:
	super(delta)  # process regular airborn directional movement
	if actor.velocity.y >= 0:
		return fall_state
	return null
