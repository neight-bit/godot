extends State
class_name MoveState

@export
var fall_state: State

@export
var idle_state: State

@export
var jump_state: State


func process_input(event: InputEvent) -> State:
	if get_jump():
		return jump_state
	return null

func process_physics(delta: float) -> State:
	parent.velocity.y += move_component.get_gravity() * delta

	var move_direction = move_component.get_movement_direction()
	parent.orientation = move_direction
	if parent.velocity.x == 0 and move_direction == 0:
		return idle_state

	parent.velocity.x = move_component.get_grounded_velocity(delta)
	parent.move_and_slide()
	
	if !parent.is_on_floor():
		return fall_state

	return null
