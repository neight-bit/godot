extends Node

@export
var base_move_speed: float = 80

@export
var max_speed: float = 400

@export
var acceleration: float = 1000

@export
var deceleration_factor: float = 3

@export
var jump_height: float = 150

@export
var jump_time_to_peak: float = .5

@export
var jump_time_to_descent: float = .4

@export
var air_control: float = 800

@export
var jump_buffer_time: float = .1

var parent: CharacterBody2D

@onready var jump_velocity : float = ((2.0 * jump_height) / jump_time_to_peak) * -1.0
@onready var jump_gravity: float = ((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)) * -1.0
@onready var fall_gravity: float = ((-2.0 * jump_height) / (jump_time_to_descent * jump_time_to_descent)) * -1.0


func get_gravity() -> float:
	return jump_gravity if parent.velocity.y < 0.0 else fall_gravity

func get_movement_direction() -> float:
	return Input.get_axis('move_left', 'move_right')
	
func wants_jump() -> bool:
	return Input.is_action_just_pressed('jump')

func get_parent_acceleration() -> float:
	'''Run acceleration can be turned on/off on a per-character basis'''
	if (parent.get("has_acceleration") and parent.has_acceleration):
		if (parent.get("acceleration_factor") and parent.acceleration_factor):
			acceleration = parent.acceleration_factor
		return acceleration
	else: 
		return 0.0

func get_parent_deceleration() -> float:
	"""Check if the character is reversing direction or stopping,"""
	if (parent.get("has_acceleration") and parent.has_acceleration):
		if (parent.get("deceleration_factor") and parent.deceleration_factor):
			deceleration_factor = parent.deceleration_factor
	if sign(parent.velocity.x) != sign(get_movement_direction()):
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
			parent.velocity.x, 
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
			parent.velocity.x, 
			move_direction * max_speed, 
			acceleration * deceleration * delta
		)
	else:
		# reglar, linear velocity
		velocity = move_direction * base_move_speed

	return velocity

func get_jump(pre_buffered: bool = false) -> bool:
	"""The pre_buffered argument overrides forces wants_jump to true.
	This is because the call that evaluates a jump buffering request processes jump input several
	frames before get_jump is called.  By then the jump input not likely active anymore"""
	var char_wants_jump: bool
	char_wants_jump = true if pre_buffered else wants_jump()
	if parent.remaining_jumps <= 0:
		return false
	
	if parent.is_on_floor():
		if parent.get('is_dashing') and parent.is_dashing:
			if parent.can_jump_while_dashing:
				return char_wants_jump
			else:
				return false
		
		return char_wants_jump
	
	else:
		if parent.get('is_dashing') and parent.is_dashing:
			if parent.can_jump_while_air_dashing:
				return char_wants_jump
			else:
				return false
		return char_wants_jump

func reset_jumps() -> void:
	if parent.is_on_floor():
		parent.remaining_jumps = parent.max_jumps


func can_buffer_jump() -> bool:
	var ground_nearby = false
	var char_collider = parent.get_node('collider')
	var bottom_y = char_collider.global_position.y + char_collider.shape.height/2
	var origins = [
			Vector2(char_collider.global_position.x - char_collider.shape.radius, bottom_y), # Left-bottom
			Vector2(char_collider.global_position.x, bottom_y), # Center-bottom
			Vector2(char_collider.global_position.x + char_collider.shape.radius, bottom_y)  # Right-bottom
		]
		
	for origin in origins:
		var raycast = RayCast2D.new()
		raycast.enabled = true
		raycast.position = origin
		raycast.target_position = Vector2(
			0,
			jump_buffer_time * abs(parent.velocity.y)
		)
		raycast.collision_mask = 1
		raycast.collide_with_bodies = true
		add_child(raycast)
		raycast.force_raycast_update()
		if raycast.is_colliding():
			ground_nearby = true
		raycast.queue_free()

	return ground_nearby
