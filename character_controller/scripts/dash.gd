extends MoveState

@export
var move_state: State

@export
var dash_time: float = move_component.dash_time

var dash_timer := 0.0

var direction := 1.0

func enter() -> void:
	super()
	dash_timer = dash_time
	# Use direction the character is facing instead of direction of motion
	direction = -1 if parent.animations.flip_h else 1


func process_physics(delta: float) -> State:
	dash_timer -= delta
	if dash_timer <= 0.0:
		super.process_physics(delta)

	var move_direction = get_movement_direction()
	if parent.velocity.x == 0 and move_direction == 0:
		return idle_state
	if parent.animations:
		parent.animations.flip_h = move_direction < 0

	parent.velocity.x = move_component.get_grounded_velocity(delta)
	parent.move_and_slide()
	
	if !parent.is_on_floor():
		return fall_state

	return null
