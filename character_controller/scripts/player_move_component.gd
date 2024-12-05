extends Node

@export
var move_speed: float = 200

@export
var max_speed: float = 1000

@export
var jump_height: float

@export
var jump_time_to_peak: float

@export
var jump_time_to_descent: float

@export
var air_control: float

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

func get_airborne_velocity(delta, initial_horizontal_velocity) -> float:
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
	#return move_toward(
		#parent.velocity.x, 
		#direction * max_speed, 
		#air_control * delta
	#)
