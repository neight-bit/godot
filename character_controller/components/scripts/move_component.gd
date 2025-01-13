extends Component

@export
var has_acceleration: bool = true

@export_range(0.0, 5000, 1) var acceleration_factor: float = 800

@export
var base_move_speed: float = 300

@export
var max_speed: float = 400

@export
var deceleration_factor: float = 4

@export
var air_control: float = 800


func _ready():
	print("initializing move component")
	actions = [
		["get_movement_direction",				self, {}],
		["get_actor_acceleration",				self, {}],
		["get_actor_deceleration",				self, {}],
		['get_airborne_velocity',				self, {'delta': 0, "initial_horizontal_velocity": 0}],
		["get_grounded_velocity",				self, {'delta': 0}],
		["get_gravity",							self, {}],
		["get_max_speed",						self, {}],
	]

func get_max_speed() -> float:
	return max_speed

func get_movement_direction() -> float:
	return Input.get_axis('move_left', 'move_right')

func get_actor_acceleration() -> float:
	if has_acceleration:
		return acceleration_factor
	else: 
		return 1.0

func get_actor_deceleration() -> float:
	"""Check if the character is reversing direction or stopping,"""
	if has_acceleration and sign(actor.velocity.x) != sign(get_movement_direction()):
		return deceleration_factor
	else:
		return 1.0
	
func get_airborne_velocity(delta: float, initial_horizontal_velocity: float) -> float:
	"""Allow a character to continue at the absolute speed they had when they left the ground.
	If they change direction in mid-air, they can re-accelerate back up to the initial speed in the opposie direction, 
	but not exceed intial velocity"""

	if not has_acceleration:
		return get_grounded_velocity(delta)

	var direction: float = get_movement_direction()
	var target_velocity = [abs(initial_horizontal_velocity), max_speed / 3].max()

	var clamped_velocity = clamp(
		move_toward(
			actor.velocity.x, 
			target_velocity  * direction, 
			air_control * delta
		),
		-target_velocity,
		target_velocity
	)
	
	if sign(clamped_velocity) != sign(initial_horizontal_velocity) and direction != 0:
		clamped_velocity = move_toward(
			clamped_velocity,
			target_velocity * direction,
			air_control * delta
	)
	return clamped_velocity

func get_grounded_velocity(delta: float, kill_input: bool=false):
	"""Velocity can be determined via upstream properties to either be a flat value, or use accleration.
	kill_input: allows the player to gracefully delerate from a moving velocty instead of instantly stopping.
	"""
	var velocity: 		float
	var move_direction:	float
	var acceleration: 	float = get_actor_acceleration()
	var deceleration:	float = get_actor_deceleration()

	if kill_input:
		move_direction = 0
	else:
		move_direction = get_movement_direction()

	if has_acceleration:
		velocity = move_toward(
			actor.velocity.x, 
			move_direction * max_speed, 
			acceleration * deceleration * delta
		)
	else:
		# reglar, linear velocity
		velocity = move_direction * base_move_speed

	return velocity
