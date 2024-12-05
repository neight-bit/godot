extends State

@export
var fall_state: State

@export 
var move_state: State

@export
var jump_state: State

func enter() -> void:
	super()
	parent.velocity.x = 0

func process_input(event: InputEvent) -> State:
	if move_component.wants_jump():
		if parent.is_on_floor():
			return jump_state

	if move_component.get_movement_direction() != 0.0:
		return move_state

	return null

func process_physics(delta: float) -> State:
	parent.velocity.y += move_component.get_gravity() * delta

	parent.move_and_slide()

	if !parent.is_on_floor():
		return fall_state

	return null
