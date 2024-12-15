extends Component

@export
var dash_time: float = .25

@export 
var dash_speed: float = 2 * max_speed

@export
var dash_cooldown_time: float = 1

@export
var can_dash: bool = true

func wants_dash() -> bool:
	return Input.is_action_just_pressed('dash')

func get_dash() -> bool:
	if actor.has_node("DashCooldownTimer"):
		return false
	if wants_dash():
		if not actor.can_dash:
			return false
		if not actor.is_on_floor():
			if not actor.can_air_dash:
				return false
		return true
	return false

func get_dash_velocity() -> float:
	return dash_speed * actor.orientation

func get_dash_cooldown_timer() -> Timer:
	var cooldown_timer = Timer.new()
	cooldown_timer.one_shot = true
	cooldown_timer.wait_time = dash_cooldown_time
	cooldown_timer.name = "DashCooldownTimer"
	cooldown_timer.timeout.connect(_on_dash_cooldown_timeout.bind(cooldown_timer))
	return cooldown_timer

func _on_dash_cooldown_timeout(timer) -> void:
	var cooldown_timer:Timer = timer
	if cooldown_timer:
		cooldown_timer.queue_free()