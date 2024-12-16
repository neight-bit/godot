extends Component

@export
var has_acceleration: bool = true

@export_range(0.0, 5000, 1) var acceleration_factor: float = 1.0

@export
var base_move_speed: float = 80

@export
var max_speed: float = 400

@export
var acceleration: float = 1000

@export
var deceleration_factor: float = 3

@export
var air_control: float = 800


func _ready():
	actions = [
		["wants_jump", 			self, {}],
		["get_jump",			self, {"pre_buffered": false}],
		["reset_jumps",			self, {}],
		['set_max_jumps',		self, {'num_max_jumps': 1}],
		["get_remaining_jumps",	self, {}],
		["get_gravity",			self, {}],
	]

func get_movement_direction() -> float:
	return Input.get_axis('move_left', 'move_right')

func get_parent_acceleration() -> float:
	'''Run acceleration can be turned on/off on a per-character basis'''
	if has_acceleration:
		return acceleration_factor
	else: 
		return 1.0

func get_parent_deceleration() -> float:
	"""Check if the character is reversing direction or stopping,"""
	if has_acceleration:
		if (parent.get("deceleration_factor") and parent.deceleration_factor):
			deceleration_factor = parent.deceleration_factor
	if sign(actor.velocity.x) != sign(get_movement_direction()):
		return deceleration_factor
	else:
		return 1.0
	
func get_airborne_velocity(delta: float, initial_horizontal_velocity: float) -> float:
	"""Allow a character to continue at the absolute speed they had when they left the ground.
	If they change direction in mid-air, they can re-accelerate back up to the initial speed in the opposie direction, 
	but not exceed intial velocity"""
	
	var direction: float = get_movement_direction()
	var target_velocity = abs(initial_horizontal_velocity) * direction
	var max_allowed_speed = max(
		abs(initial_horizontal_velocity), 
		max_speed
	)
	var clamped_velocity = clamp(
		move_toward(
			actor.velocity.x, 
			target_velocity, 
			air_control * delta
		),
		-max_allowed_speed,
		max_allowed_speed
	)
	if sign(clamped_velocity) != sign(initial_horizontal_velocity) and direction != 0:
		clamped_velocity = move_toward(
			clamped_velocity,
			target_velocity,
			air_control * delta
	)
	return clamped_velocity

func get_grounded_velocity(delta: float):
	"""Velocity can be determined via upstream properties to either be a flat value, or use accleration"""
	var velocity: float
	var move_direction: float = get_movement_direction()
	
	# Get acceleration from character or use default setting
	acceleration = get_parent_acceleration()
	# Get deceleration factor 
	# How quickly does the character turn around or come to a stop
	var deceleration = get_parent_deceleration()

	if acceleration > 0:
		velocity = move_toward(
			actor.velocity.x, 
			move_direction * max_speed, 
			acceleration * deceleration * delta
		)
	else:
		# reglar, linear velocity
		velocity = move_direction * base_move_speed

	return velocity