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

@export
var jump_component: Component

func _init() -> void:
	required_components = ["jump_component"]

func enter() -> void:
	super()
	initial_horizontal_velocity = actor.velocity.x
	actor.velocity.y = move_component.jump_velocity
	actor.remaining_jumps -= 1
	
func process_input(_event: InputEvent) -> State:
	if move_component.get_dash():
		return dash_state
	if move_component.get_jump():
		return self
	return null

func process_physics(delta: float) -> State:
	actor.velocity.y += move_component.get_gravity() * delta
	if actor.velocity.y > 0:
		return fall_state
	
	var movement_direction = move_component.get_movement_direction()
	actor.orientation = movement_direction
	move_component.get_airborne_velocity(delta, initial_horizontal_velocity)
	actor.move_and_slide()

	return null
