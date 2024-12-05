extends State

@export
var fall_state: State

@export
var idle_state: State

@export
var jump_state: State


func process_input(event: InputEvent) -> State:
	if move_component.wants_jump() and parent.is_on_floor():
		return jump_state
	return null

func process_physics(delta: float) -> State:
	parent.velocity.y += move_component.get_gravity() * delta

	var move_direction = move_component.get_movement_direction()
	if parent.velocity.x == 0 and move_direction == 0:
		return idle_state
	if parent.animations:
		parent.animations.flip_h = move_direction < 0

	parent.velocity.x = move_component.get_grounded_velocity(delta)
	parent.move_and_slide()
	
	if !parent.is_on_floor():
		return fall_state

	return null
