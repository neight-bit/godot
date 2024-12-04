extends State

@export
var fall_state: State

@export
var idle_state: State

@export
var jump_state: State


func get_acceleration(current_speed: float, delta: float):
	current_speed = abs(current_speed)
	return 3 * delta * (max_speed - current_speed) + 1

func process_input(event: InputEvent) -> State:
	if move_component.wants_jump() and parent.is_on_floor():
		return jump_state
	return null

func process_physics(delta: float) -> State:
	parent.velocity.y += gravity * delta
	parent.acceleration = get_acceleration(parent.velocity.x, delta)
	#var movement = move_component.get_movement_direction() * move_speed
	var move_direction = move_component.get_movement_direction()
	if move_direction == 0:
		return idle_state
	if parent.animations:
		parent.animations.flip_h = move_direction < 0
	
	# Without acceleration
	#parent.velocity.x = move_direction * move_speed

	if abs(parent.velocity.x) < move_speed:
		parent.velocity.x = move_direction * move_speed
	else:
		parent.velocity.x = move_toward(
			parent.velocity.x, 
			move_direction * max_speed, 
			parent.acceleration
		)
	
	parent.move_and_slide()
	
	if !parent.is_on_floor():
		return fall_state
		
	return null
	
