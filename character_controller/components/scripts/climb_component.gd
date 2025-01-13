extends Component

# region setup

@export var can_use_ladders: bool = true

@export var climbing_speed := {up=150, down=300}

@export var can_jump_during_climb: bool = true

@onready
var current_ladder: Ladder

@onready
var ladder_below_actor: Ladder

@onready
var is_on_ladder: bool:
	get:
		if current_ladder == null:
			return false
		return true

@onready
var is_above_ladder: bool:
	get:
		if ladder_below_actor == null:
			return false
		return true

@onready
var pass_thru_platform_collsion_mask: int = Utils.get_layer_by_name("pass_thru")

@onready
var ladder_collsion_mask: int = Utils.get_layer_by_name("ladders")

func _ready():
	print("initializing climb component")
	EventBus.service().subscribe("BODY_ON_LADDER_DETECTION", self, "_on_body_on_ladder_event")
	
	actions = [
		["get_climb",						self, {}],
		["get_climb_direction",				self, {}],
		["get_climb_velocity",				self, {}],
		["is_currently_on_ladder",			self, {}],
		["is_currently_above_ladder",		self, {}],
		["start_climbing",					self, {}],
		["reset_ladder_pass_thru_collider",	self, {}],
		["can_jump_while_climbing",			self, {}],
	]

# endregion


# region methods

func _on_body_on_ladder_event(event: Event):
	if event.body == actor:
		if event.is_on_ladder:
			if event.section == "main":
				current_ladder = event.ladder
			elif event.section == "top":
				ladder_below_actor = event.ladder

		if ! event.is_on_ladder:
			if event.section == "main":
				reset_ladder_pass_thru_collider()
				current_ladder = null
			elif event.section == "top":
				ladder_below_actor = null

func is_currently_on_ladder() -> bool:
	return is_on_ladder

func is_currently_above_ladder() -> bool:
	return is_above_ladder

func get_climb() -> bool:
	if can_use_ladders:
		if is_on_ladder:
			if Input.is_action_pressed("climb_up") \
			or Input.is_action_pressed("climb_down"):
				return true
		elif is_above_ladder:
			if Input.is_action_pressed("climb_down"):
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
	if not current_ladder:
		current_ladder = ladder_below_actor
		ladder_below_actor = null
	actor.position.x = current_ladder.position.x
	current_ladder.get_pass_thru_platfrom().collision_layer = 0

func reset_ladder_pass_thru_collider() -> void:
	if current_ladder:
		current_ladder.get_pass_thru_platfrom().collision_layer = pass_thru_platform_collsion_mask

func can_jump_while_climbing() -> bool:
	return can_jump_during_climb

# endregion
