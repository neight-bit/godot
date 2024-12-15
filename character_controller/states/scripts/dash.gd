extends State

@export
var idle_state: State

@export
var move_state: State

@export
var jump_state: State

@export
var fall_state: State

var dash_timer := 0.0

func enter() -> void:
	super()
	dash_timer = move_component.dash_time
	actor.is_dashing = true

func exit() -> void:
	actor.is_dashing = false
	var cooldown_timer = move_component.get_dash_cooldown_timer()
	actor.add_child(cooldown_timer)
	cooldown_timer.start()

func process_input(event: InputEvent) -> State:
	if move_component.get_jump():
		print("jump 4 u")
		return jump_state
	print("no jump 4 u")
	return null

func process_physics(delta: float) -> State:
	dash_timer -= delta
	if dash_timer <= 0.0:
		if actor.velocity.y > 0:
			return fall_state
		if move_component.get_movement_direction() != 0.0:
			return move_state
		return idle_state
	
	actor.velocity.y = 0
	actor.velocity.x = move_component.get_dash_velocity()
	actor.move_and_slide()
	
	return null
