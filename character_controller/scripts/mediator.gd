class_name Mediator
extends Node

@export
var component_manager: ComponentManager

@export
var state_machine: StateMachine

@export
var actor: Node2D

var registry := {}

var targets := []

var actions = [
]

func init(actor_obj, state_machine_node, component_manager_node) -> void:
	print("Initializing mediator")
	actor = actor_obj
	state_machine = state_machine_node
	component_manager = component_manager_node
	for action in actions:
		register_action(action)
	# var event = MediatorReadyEvent.new(actor, self)
	# EventBus.service().broadcast(event)
	print("Mediator initialized")

func register_action(args: Array):
	""" [action_name, object_ref, [args]] """
	print("Registering action: " + args[0])
	if args[0] not in registry:
		var action_name:	String		=args[0]
		var target: 		Object		=args[1]
		var params:			Dictionary	=args[2]

		registry[action_name] = {
			"method": action_name,
			"target": target,
			"params": params
		}

func unregister_action(action_name: String) -> void:
	print("unregistering action: " + action_name)
	registry.erase(action_name)

func request(action_name: String, args: Array = []):
	if registry.has(action_name):
		var action = registry[action_name]
		var target = action.target
		var method_name = action.method
		if action.params.is_empty():
			return target.call(method_name)

		return target.callv(method_name, args)
	
	print("Action not recognized:", action_name)
	return null

class MediatorReadyEvent extends Event:
	const id := "MEDIATOR_READY"
	var actor
	var mediator
	
	func _init(actor_node, mediator_node):
		self.actor = actor_node
		self.mediator = mediator_node
