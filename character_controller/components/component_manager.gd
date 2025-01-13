class_name ComponentManager
extends Node

@export
var actor: Node2D

@export
var mediator: Mediator

@export
var components: Dictionary = {}

@export
var COMPONENTS_PATH := "res://components/scripts/"

@export
var null_component_script = preload("res://components/scripts/null_component.gd")

var actions = []
func init(actor_node: Node2D, mediator_node: Mediator) -> void:
	print("Initializing component manager")
	actor = actor_node
	mediator = mediator_node
	_audit_registration()
	print("Component manager initialized")


func get_component(component_name: String) -> Component:
	print("getting component: " + component_name)
	if not components.has(component_name):
		_load_component(component_name)
	var component: Component = components[component_name]
	return component


func _load_component(component_name: String) -> void:
	print("loading component: " + component_name)
	var component_script_name: String = _normalize_component_path(component_name)
	var script = load(component_script_name)
	var component = script.new() as Component
	component.name=component_name
	add_child(component)


func _audit_registration() -> void:
	print("Auditing component registration.")
	
	var children = get_children()
	# Register any new children
	for child in children:
		_register_component(child)
	
	# Clean up dangling references in the registry
	for component_name in components:
		var component = components[component_name]
		if component not in children:
			# This is a band-aid that just prevents crashing when we close the game scene.
			# The components actions won't be unregistered if it is freed before unregistration.
			# TODO: learn how to actually handle object clean-up
			if is_instance_valid(component):
				_unregister_component(component)
	
	print("Finished auditing component registration.")


func _register_component(component: Component) -> void:
	print("registering component: " + component.name)
	if not components.has(component.name):
		components[component.name] = component
	if !component.mediator:
		component.mediator = mediator
	if !component.manager:
		component.manager = self
	if !component.actor:
		component.actor = actor
	for action in component.actions:
		mediator.register_action(action)
	print("Finished registering component: " + str(component))


func _unregister_component(component: Component):
	print("unregistering component: " + str(component.name))
	for action in component.actions:
		mediator.unregister_action(action[0])
	components.erase(component)
	component.clean_up()
	print("Finished unregistering component: " + str(component.name))


func _normalize_component_path(component_name: String) -> String:
	if ! component_name.begins_with(COMPONENTS_PATH):
		component_name = COMPONENTS_PATH + component_name
	if ! component_name.ends_with(".gd"):
		component_name = component_name + ".gd"
	return component_name


func _notification(what) -> void:
	if what == NOTIFICATION_CHILD_ORDER_CHANGED:
		print("order changed")
		_audit_registration()
