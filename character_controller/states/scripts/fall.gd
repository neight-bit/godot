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

var initial_horizontal_velocity: float

var jump_buffered: bool


func enter() -> void:
	super()
	initial_horizontal_velocity = actor.velocity.x
	jump_buffered = false

func process_input(_event: InputEvent) -> State:
	if mediator.request("get_dash"):
		return dash_state

	if mediator.request("get_climb"):
		return climb_state

	if mediator.request("wants_jump"):
		# First see if we can use jump buffer
		# This is so that an early jump button press is not accidentally interpreted
		# as an attempt to double-jump
		if mediator.request("can_buffer_jump"):
			jump_buffered = true
			return null

		if mediator.request("get_jump"):
			return jump_state

	return null

func process_physics(delta: float) -> State:
	actor.velocity.y += mediator.request("get_gravity") * delta
	var movement_direction = mediator.request("get_movement_direction")
	mediator.request("set_orientation", [movement_direction])
	actor.velocity.x = mediator.request("get_airborne_velocity", [delta, initial_horizontal_velocity])
	actor.move_and_slide()

	if actor.is_on_floor():
		if jump_buffered:
			mediator.request("reset_jumps")
			# Pass in the true argument so simulate a jump button press
			# Since the input likely triggered several ticks ago and is no longer firing
			if mediator.request("get_jump", [true]):
				return jump_state
		# TODO: This animation doesn't actually play yet because it is overridden by the baste state's enter.animations.play method
		if animation_player and "land" in animation_player.get_animation_list():
			animation_player.play("land")
		if movement_direction != 0:
			return move_state
		return idle_state

	return null
