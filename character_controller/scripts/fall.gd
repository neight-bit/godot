extends State

@export
var idle_state: State

@export 
var move_state: State

@export 
var jump_state: State

@export 
var dash_state: State

var initial_horizontal_velocity: float

func enter() -> void:
	super()
	initial_horizontal_velocity = parent.velocity.x

func process_input(_event: InputEvent) -> State:
	if move_component.get_dash():
		return dash_state
	if move_component.get_jump():
		return jump_state
	return null

func process_physics(delta: float) -> State:
	parent.velocity.y += move_component.get_gravity() * delta

	var movement_direction = move_component.get_movement_direction()
	parent.orientation = movement_direction
	parent.velocity.x = move_component.get_airborne_velocity(delta, initial_horizontal_velocity)
	parent.move_and_slide()
	
	if parent.is_on_floor():
		if animations and "land" in animations.sprite_frames.get_animation_names():
			animations.play("land")
		if movement_direction != 0:
			return move_state
		return idle_state

	return null
