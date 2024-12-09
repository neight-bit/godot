extends State

@export
var fall_state: State

@export 
var move_state: State

@export
var idle_state: State

@export
var dash_state: State

var initial_horizontal_velocity: float

func enter() -> void:
	super()
	initial_horizontal_velocity = parent.velocity.x
	parent.velocity.y = move_component.jump_velocity
	parent.remaining_jumps -= 1
	
func process_input(_event: InputEvent) -> State:
	if move_component.get_dash():
		return dash_state
	if move_component.get_jump():
		return self
	return null

func process_physics(delta: float) -> State:
	parent.velocity.y += move_component.get_gravity() * delta
	if parent.velocity.y > 0:
		return fall_state
	
	var movement_direction = move_component.get_movement_direction()
	parent.orientation = movement_direction
	move_component.get_airborne_velocity(delta, initial_horizontal_velocity)
	parent.move_and_slide()

	return null
