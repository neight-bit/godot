extends Component

@export
var dash_time: float = .25

@export
var dash_cooldown_time: float = 1

@export
var _can_dash: bool = true

@export
var _can_air_dash: bool = true

@export
var _can_jump_while_dashing: bool = true

@export
var _can_jump_while_air_dashing: bool = true

func _ready():
	actions = [
		["wants_dash", 					self, {}],
		["get_dash",					self, {}],
		["get_dash_velocity",			self, {}],
		['start_dashing',				self, {}],
		['stop_dashing',				self, {}],
		['is_dashing',					self, {}],
		['is_dash_cooling_down',		self, {}],
		['toggle_dash',					self, {}],
		['toggle_air_dash',				self, {}],
		['can_dash',					self, {}],
		['can_air_dash',				self, {}],
		['can_jump_while_dashing',		self, {}],
		['can_jump_while_air_dashing',	self, {}],
	]

func wants_dash() -> bool:
	return Input.is_action_just_pressed('dash')

func get_dash() -> bool:
	if actor.has_node("DashCooldownTimer"):
		return false
	if wants_dash():
		if not _can_dash:
			return false
		if not actor.is_on_floor():
			if not _can_air_dash:
				return false
		return true
	return false

func get_dash_velocity() -> float:
	var dash_speed = 2 * mediator.request("get_max_speed")
	return dash_speed * mediator.request("get_orientation")

func _get_dash_timer(timer_name: String):
	var timer = Timer.new()
	timer.one_shot = true
	match timer_name:
		"DashTimer": 
			timer.wait_time = dash_time
			timer.name = "DashTimer"
		"DashCooldownTimer":
			timer.wait_time = dash_cooldown_time
			timer.name = "DashCooldownTimer"
	timer.connect("timeout", _on_dash_timer_timeout.bind(timer))
	return timer

func _on_dash_timer_timeout(timer: Timer) -> void:
	print("Timer ended: " + timer.name)
	timer.queue_free()

func start_dashing() -> void:
	if not _has_timer("DashTimer"):
		var new_dash_timer = _get_dash_timer("DashTimer")
		add_child(new_dash_timer)
		new_dash_timer.start()

func stop_dashing() -> void:
	"""Override the dash timer and manually trigger its cleanup process""" 
	if _has_timer("DashTimer"):
		var dash_timer: Timer = _get_timer("DashTimer")
		_on_dash_timer_timeout(dash_timer)
	if not _has_timer("DashCooldownTimer"):
		var cooldown_timer: Timer = _get_dash_timer("DashCooldownTimer")
		add_child(cooldown_timer)
		cooldown_timer.start()

func is_dashing() -> bool:
	return _has_timer("DashTimer")

func is_dash_cooling_down() -> bool:
	return _has_timer("DashCooldownTimer")

func toggle_dash() -> void:
	_can_dash = !_can_dash

func toggle_air_dash() -> void:
	_can_air_dash = !_can_air_dash

func can_jump_while_dashing() -> bool:
	return _can_jump_while_dashing

func can_jump_while_air_dashing() -> bool:
	return _can_jump_while_air_dashing

func _has_timer(timer_name: String) -> bool:
	for child in get_children():
		if child.name == timer_name:
			return true
	return false

func _get_timer(timer_name: String) -> Timer:
	for child in get_children():
		if child.name == timer_name:
			return child
	return null
