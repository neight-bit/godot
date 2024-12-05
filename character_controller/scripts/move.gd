extends State

@export
var fall_state: State

@export
var idle_state: State

@export
var jump_state: State

@export
var acceleration: float = 1500


func process_input(event: InputEvent) -> State:
	if move_component.wants_jump() and parent.is_on_floor():
		return jump_state
	return null

func process_physics(delta: float) -> State:
	if parent.acceleration:
		acceleration = parent.acceleration
	parent.velocity.y += move_component.get_gravity() * delta

	var move_direction = move_component.get_movement_direction()
	if move_direction == 0:
		return idle_state
	if parent.animations:
		parent.animations.flip_h = move_direction < 0

	if (parent.get("has_acceleration") and parent.has_acceleration):
		if abs(parent.velocity.x) < move_component.move_speed:
			parent.velocity.x = move_direction * move_component.move_speed
		else:
			parent.velocity.x = move_toward(
				parent.velocity.x, 
				move_direction * move_component.max_speed, 
				acceleration * delta
			)
	else:
		parent.velocity.x = move_direction * move_component.move_speed

	parent.move_and_slide()
	
	if !parent.is_on_floor():
		return fall_state

	return null
