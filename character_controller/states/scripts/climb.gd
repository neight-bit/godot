extends State

@export
var move_state: State

@export
var jump_state: State

@export
var fall_state: State

@export
var idle_state: State

func enter() -> void:
	super()
	animations.stop()
	actor.velocity.x = 0
	mediator.request("start_climbing")

func exit() -> void:
	super()
	animations.speed_scale = 1
	mediator.request("stop_climbing")

func process_input(_event: InputEvent) -> State:
	if mediator.request("get_jump"):
		return jump_state
	if actor.is_on_floor():
		if mediator.request("get_movement_direction") != 0.0:
			return move_state
	return null

func process_physics(delta: float) -> State:
	actor.velocity.y = 0
	var on_ladder = mediator.request("is_currently_on_ladder")
	if not on_ladder:
		if actor.is_on_floor():
			return idle_state
		return fall_state
	
	var climb_velocity = mediator.request("get_climb_velocity")
	if climb_velocity:
		actor.velocity.y = climb_velocity
		if climb_velocity > 1:
			animations.speed_scale = -1
			animations.play(animation_name)
		elif climb_velocity < 0:
			animations.speed_scale = 1
			animations.play(animation_name)
	else:
		animations.speed_scale = 1
		animations.pause()

	actor.move_and_slide()

	return null
