extends Component

func _ready():
	actions = [
		["get_attack",				self, {}],
	]

func get_attack() -> bool:
	if Input.is_action_just_pressed("attack"):
		return true
	return false
