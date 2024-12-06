extends State

@export
var idle_state: State

@export 
var move_state: State

var initial_horizontal_velocity: float

func enter() -> void:
	super()
	initial_horizontal_velocity = parent.velocity.x

func process_physics(delta: float) -> State:
	parent.velocity.y += move_component.get_gravity() * delta

	var movement_direction = get_movement_direction()
	if movement_direction != 0 and animations:
		animations.flip_h = movement_direction < 0
	parent.velocity.x = move_component.get_airborne_velocity(delta, initial_horizontal_velocity)
	parent.move_and_slide()
	
	if parent.is_on_floor():
		if movement_direction != 0:
			return move_state
		return idle_state

	return null
