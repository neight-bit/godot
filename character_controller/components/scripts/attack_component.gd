extends Component

func _ready():
	print("initializing attack component")
	actions = [
		["get_attack",		self, {}],
		["wants_attack",	self, {}],
	]

func wants_attack() -> bool:
	if Input.is_action_just_pressed("attack"):
		return true
	return false

func get_attack() -> bool:
	return wants_attack()
