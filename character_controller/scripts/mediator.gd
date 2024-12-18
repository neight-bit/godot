class_name Mediator
extends Node

@export
var component_manager: ComponentManager

@export
var state_machine: StateMachine

@export
var actor: Node2D

var actions := {
	# [action_name, object_ref, [args]]
}

func init(actor_obj, component_manager_obj, state_machine_obj) -> void:
	print("Initializing mediator")
	actor=actor_obj
	component_manager=component_manager_obj
	state_machine=state_machine_obj

func register_action(args: Array):
	print("Registering action: " + args[0])
	if args[0] not in actions:
		var action_name:	String		=args[0]
		var target: 		Object		=args[1]
		var params:			Dictionary	=args[2]

		actions[action_name] = {
			"method": action_name,
			"target": target,
			"params": params
		}

func unregister_action(action_name: String) -> void:
	print("unregistering action: " + action_name)
	actions.erase(action_name)


func request(action_name: String, args: Array = []):
	if actions.has(action_name):
		var action = actions[action_name]
		var target = action.target
		var method_name = action.method
		if action.params.is_empty():
			return target.call(method_name)

		return target.callv(method_name, args)
	
	print("Action not recognized:", action_name)
	return null
