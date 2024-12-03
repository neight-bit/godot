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
	parent.velocity.y += gravity * delta
	
	var movement = move_component.get_movement_direction() * move_speed
	if movement == 0:
		return idle_state
	parent.animations.flip_h = movement < 0
	parent.velocity.x = movement
	parent.move_and_slide()
	
	if !parent.is_on_floor():
		return fall_state
		
	return null
	
