extends Node
class_name Component

@export
var enabled: bool = true

@export
var manager: ComponentManager

var mediator: Mediator

var actions: Array = []

var properties: Dictionary = {}

var orientation: int = 1

@export
var actor: Node2D

func _ready():
	print("initializing base component")
	actions = [
		["get_orientation", self,	 	{}],
		["set_orientation", self,		{"value": 1}],
		["get_component", 	manager,	{"component_name": null}]
	]

func reset():
	pass

func clean_up():
	queue_free()

func get_orientation():
	return orientation

func set_orientation(value: int) -> void:
	if value != 0:
		orientation = value
		var event = ActorOrientationEvent.new(actor, value)
		EventBus.service().broadcast(event)

class ActorOrientationEvent extends Event:
	const id = "ActorOrientationEvent"
	var actor
	var orientation: int

	func _init(actor_node, orientation_value: int) -> void:
		super(id)
		self.actor = actor_node
		self.orientation = orientation_value
