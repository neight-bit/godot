extends State
class_name Airborne

@export
var fall_state: State

@export
var airborne_attack_state: State


var initial_horizontal_velocity: float

func enter() -> void:
	super()
	initial_horizontal_velocity = actor.velocity.x

func process_input(InputEvent) -> State:
	if mediator.request("get_attack"):
		return airborne_attack_state
	return null


func process_physics(delta: float) -> State:
	"""Apply velocity forces, but let the child states determine what to do about them.
	This is because the results of move_and_slide() may not finish processing in this frame,
	and it's possible to get stuck in jump state."""
	actor.velocity.y += mediator.request("get_gravity") * delta

	var movement_direction = mediator.request("get_movement_direction")
	mediator.request("set_orientation", [movement_direction])
	actor.velocity.x = mediator.request("get_airborne_velocity", [delta, initial_horizontal_velocity])
	actor.move_and_slide()

	return null
