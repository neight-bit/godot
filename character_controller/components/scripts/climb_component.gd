extends Component

@export var can_use_ladders: bool = true

@export var climbing_speed := {up=150, down=300}

@onready
var _on_ladder: bool

@onready
var current_ladder: Ladder

@onready
var is_on_ladder: bool:
	get:
		return _on_ladder
	set(value):
		_on_ladder = value

func _ready():
	EventBus.service().subscribe("BODY_ON_LADDER_DETECTION", self, "_on_body_on_ladder_event")
	actions = [
		["get_climb",				self, {}],
		["get_climb_direction",		self, {}],
		["get_climb_velocity",		self, {}],
		["is_currently_on_ladder",	self, {}],
		["start_climbing",			self, {}],
	]

func _on_body_on_ladder_event(event: Event):
	print(event.is_on_ladder)
	if event.body == actor:
		if event.is_on_ladder:
			current_ladder = event.ladder
			is_on_ladder = true
		if ! event.is_on_ladder and is_on_ladder:
			stop_climbing()


func is_currently_on_ladder() -> bool:
	return is_on_ladder

func get_climb() -> bool:
	if can_use_ladders:
		if is_on_ladder:
			if Input.is_action_pressed("climb_up") \
			or Input.is_action_pressed("climb_down"):
				return true
	return false

func get_climb_direction() -> float:
	"""
	-1: up, 
	1:  down
	"""
	return Input.get_axis('climb_up', 'climb_down')

func get_climb_velocity() -> int:
	var direction: float = 0
	if get_climb():
		direction = get_climb_direction()
		if direction > 0:
			return direction * climbing_speed['down']
		elif direction < 0:
			return direction * climbing_speed['up']
	return 0

func start_climbing() -> void:
	actor.position.x = current_ladder.position.x
	current_ladder.get_pass_thru_platfrom().collision_layer = 0

func stop_climbing() -> void:
	current_ladder.get_pass_thru_platfrom().collision_layer = Utils.get_layer_by_name("pass_thru")
	current_ladder = null
	is_on_ladder = false

func is_just_above_ladder() -> bool:
	var ladder_below := false
	var char_collider = actor.get_node('collider')
	var raycast = RayCast2D.new()
	raycast.position = Vector2(
		char_collider.global_position.x,
		char_collider.global_position.y + char_collider.shape.height/2
	)
	raycast.target_position = Vector2(
		0,
		4
	)
	raycast.collision_mask = 4
	raycast.collide_with_bodies = true
	raycast.force_raycast_update()
	if raycast.is_colliding():
		ladder_below = true
	raycast.queue_free()
	return ladder_below
