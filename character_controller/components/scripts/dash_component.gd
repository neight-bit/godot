extends Component

@export
var dash_time: float = .25

@export
var dash_cooldown_time: float = 1

@export
var can_dash: bool = true

@export
var can_air_dash: bool = false

var dash_timer: Array[Timer]

var dash_cooldown_timer: Array[Timer]

func _ready():
	actions = [
		["wants_dash", 				self, {}],
		["get_dash",				self, {}],
		["get_dash_velocity",		self, {}],
		['start_dashing',			self, {}],
		['stop_dashing',			self, {}],
		['is_dashing',				self, {}],
		['is_dash_cooling_down',	self, {}],
		['toggle_dash',				self, {}],
		['toggle_air_dash',			self, {}],
	]

func wants_dash() -> bool:
	return Input.is_action_just_pressed('dash')

func get_dash() -> bool:
	if actor.has_node("DashCooldownTimer"):
		return false
	if wants_dash():
		if not can_dash:
			return false
		if not actor.is_on_floor():
			if not can_air_dash:
				return false
		return true
	return false

func get_dash_velocity() -> float:
	var dash_speed = 2 * mediator.request("max_speed")
	return dash_speed * actor.orientation

func _get_dash_timer(timer_name: String):
	var timer = Timer.new()
	timer.one_shot = true
	match timer_name:
		"DashTimer": 
			timer.wait_time = dash_time
			timer.name = "DashTimer"
		"DashCooldownTimer":
			timer.wait_time = dash_cooldown_time
			timer.name = "DashTimer"
	timer.timeout.connect(_on_dash_timer_timeout.bind(timer))
	return timer

func _get_dash_cooldown_timer() -> Timer:
	var cooldown_timer = Timer.new()
	cooldown_timer.one_shot = true
	cooldown_timer.wait_time = dash_cooldown_time
	cooldown_timer.name = "DashCooldownTimer"
	cooldown_timer.timeout.connect(_on_dash_timer_timeout.bind(cooldown_timer))
	return cooldown_timer

func _on_dash_timer_timeout(timer: Timer) -> void:
	if timer.name == "DashTimer":
		dash_timer = []
	if timer.name == "DashCooldownTimer":
		dash_cooldown_timer = []
	timer.queue_free()

func start_dashing() -> void:
	if len(dash_timer) < 1:
		var new_dash_timer = _get_dash_timer("DashTimer")
		dash_timer.append(new_dash_timer)
		new_dash_timer.start()

func stop_dashing() -> void:
	if len(dash_timer) > 0:
		_on_dash_timer_timeout(dash_cooldown_timer[0])

func is_dashing() -> bool:
	if len(dash_timer) > 0:
		return true
	return false

func is_dash_cooling_down() -> bool:
	if len(dash_cooldown_timer) > 0:
		return true
	return false

func toggle_dash() -> void:
	can_dash = !can_dash

func toggle_air_dash() -> void:
	can_air_dash = !can_air_dash
