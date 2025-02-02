extends Component

@export
var cancelable_attacks: Dictionary = {
	"grounded_attack": false,
	"airborne_attack": false,
}

func _ready():
	print("initializing attack component")
	actions = [
		["get_attack",			self, {}],
		["wants_attack",		self, {}],
		["can_cancel_attack",	self, {"attack_name": ""}],
	]

func wants_attack() -> bool:
	if Input.is_action_just_pressed("attack"):
		return true
	return false

func get_attack() -> bool:
	return wants_attack()
	
func can_cancel_attack(attack_name: String) -> bool:
	return cancelable_attacks.get(attack_name, false)
