extends State

func enter():
	super()
	mediator.request("start_attack", ["grounded_attack"])

func process_input(event: InputEvent) -> State:
	if animation_player.is_playing():
		if not mediator.request("can_cancel_attack"):
			return null
	if mediator.request("get_jump") and actor.is_on_floor():
		return get_state("jump")
	if mediator.request("get_dash"):
		return get_state("dash")
	if mediator.request("get_movement_direction") != 0.0:
		return get_state("move")
	if mediator.request("get_climb"):
		return get_state("climb")
	return get_state("idle")

func process_physics(delta: float) -> State:
	actor.velocity.y += mediator.request("get_gravity") * delta
	actor.velocity.x = mediator.request("get_grounded_velocity", [delta, true])
	actor.move_and_slide()
	
	if !actor.is_on_floor() and not mediator.request("is_dashing"):
		return get_state("fall")
	
	if animation_player.is_playing():
		return get_state("null")
	
	if mediator.request("get_movement_direction") != 0.0:
		return get_state("move")
	
	else: return get_state("idle")
