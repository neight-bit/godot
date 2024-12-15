class_name Mediator
extends Node

@export
var component_manager: ComponentManager

@export
var state_machine: StateMachine

@export
var actor: Node2D

var properties := {
	"orientation": 1
}

var actions := {}

func register_action(
	action_name: String,
	target: Object,
	method_name: String,
	default_args: Array=[]
):
	actions[action_name] = {
		"target": target,
		"method": method_name,
		"default_args": default_args
	}

func unregister_action(action_name: String) -> void:
	actions.erase(action_name)

# Request actions with optional override arguments
func request(action_name: String, args: Array=[]):
	if actions.has(action_name):
		var action = actions[action_name]
		var target = action.target
		var method_name = action.method
		#var default_args = action.default_args

		# Merge default arguments with override arguments
		#var args = default_args + override_args
		return target.callv(method_name, args)
	
	print("Action not recognized:", action_name)
	return null
