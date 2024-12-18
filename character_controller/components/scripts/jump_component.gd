extends Component

@export
var max_jumps: int = 1

@export
var jump_height: float = 150

@export
var jump_time_to_peak: float = .5

@export
var jump_time_to_descent: float = .4

@export 
var can_buffer_jumps: bool = true

@export
var jump_buffer_time: float = .1

var remaining_jumps: int


@onready var jump_velocity : float = ((2.0 * jump_height) / jump_time_to_peak) * -1.0
@onready var jump_gravity: float = ((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)) * -1.0
@onready var fall_gravity: float = ((-2.0 * jump_height) / (jump_time_to_descent * jump_time_to_descent)) * -1.0

func _ready():
	actions = [
		["wants_jump", 					self, {}],
		["get_jump",					self, {"pre_buffered": false}],
		["reset_jumps",					self, {}],
		['set_max_jumps',				self, {'num_max_jumps': 1}],
		["get_remaining_jumps",			self, {}],
		["get_gravity",					self, {}],
		["get_jump_velocity",			self, {}],
		["decrement_remaining_jumps",	self, {"qty": 1}],
	]

func get_gravity() -> float:
	return jump_gravity if actor.velocity.y < 0.0 else fall_gravity

func get_jump_velocity():
	return jump_velocity

func wants_jump() -> bool:
	return Input.is_action_just_pressed('jump')

func get_jump(pre_buffered: bool=false) -> bool:
	"""The pre_buffered argument overrides forces wants_jump to true.
	This is because the call that evaluates a jump buffering request processes jump input several
	frames before get_jump is called.  By then the jump input not likely active anymore"""
	var char_wants_jump: bool
	char_wants_jump = true if pre_buffered else wants_jump()
	if remaining_jumps <= 0:
		return false
	
	if actor.is_on_floor():
		if mediator.request('is_dashing'):
			if mediator.request("can_jump_while_dashing"):
				return char_wants_jump
			else:
				return false
		
		return char_wants_jump
	
	else:
		if mediator.request('is_dashing'):
			if mediator.request("can_jump_while_air_dashing"):
				return char_wants_jump
			else:
				return false
		return char_wants_jump

func reset_jumps() -> void:
	if actor.is_on_floor():
		remaining_jumps = max_jumps

func set_max_jumps(num_max_jumps: int) -> void:
	if num_max_jumps > 0:
		max_jumps = 0
	else:
		max_jumps = num_max_jumps

func get_remaining_jumps() -> int:
	return remaining_jumps

func decrement_remaining_jumps(qty: int) -> void:
	if remaining_jumps > 0:
		remaining_jumps -= qty

func can_buffer_jump() -> bool:
	var ground_nearby = false
	var char_collider = actor.get_node('collider')
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
			jump_buffer_time * abs(actor.velocity.y)
		)
		raycast.collision_mask = 1
		raycast.collide_with_bodies = true
		add_child(raycast)
		raycast.force_raycast_update()
		if raycast.is_colliding():
			ground_nearby = true
		raycast.queue_free()

	return ground_nearby