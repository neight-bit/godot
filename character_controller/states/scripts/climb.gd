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
	actor.velocity.x = 0
	super()
	animation_player.stop()
	mediator.request("start_climbing")

func exit() -> void:
	super()
	animation_player.speed_scale = 1
	mediator.request("reset_ladder_pass_thru_collider")

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
		return idle_state
	
	var climb_velocity = mediator.request("get_climb_velocity")
	if climb_velocity:
		actor.velocity.y = climb_velocity
		if climb_velocity > 1:
			animation_player.speed_scale = -1
			animation_player.play(animation_name)
		elif climb_velocity < 0:
			animation_player.speed_scale = 1
			animation_player.play(animation_name)
	else:
		animation_player.pause()
		animation_player.speed_scale = 1
	actor.move_and_slide()

	return null
