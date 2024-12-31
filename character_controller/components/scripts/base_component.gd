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
		["get_orientation", self, {}],
		["set_orientation", self, {"value": 1}],
	]

func reset():
	pass

func clean_up():
	queue_free()

func get_orientation():
	return orientation

func set_orientation(value: int) -> void:
	if value < 0:
		actor.animations.flip_h = true
		orientation = value
	if value > 0:
		actor.animations.flip_h = false
		orientation = value
	if value == 0:
		# don't flip the sprite's direction
		pass
