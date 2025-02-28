extends Component

@export
var cancelable_attacks: Dictionary = {
	"grounded_attack": false,
	"airborne_attack": false,
}

var wants_attack: bool = false
var current_weapon: String = "sword"

func _ready():
	print("initializing attack component")
	actions = [
		["get_wants_attack",	self, {}],
		["set_wants_attack",	self, {'value': false}],
		["get_attack",			self, {}],
		["wants_attack",		self, {}],
		["can_cancel_attack",	self, {"attack_name": ""}],
		["attack",				self, {"attack_name": "grounded_attack"}]
	]

func set_wants_attack(value: bool) -> void:
	wants_attack = value

func get_wants_attack() -> bool:
	return wants_attack

func get_attack() -> bool:
	"""Flesh this out with additional conditional logic"""
	return wants_attack

func can_cancel_attack(attack_name: String) -> bool:
	return cancelable_attacks.get(attack_name, false)

func attack(attack_name: String) -> void:
	pass
