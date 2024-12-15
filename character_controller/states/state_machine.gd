class_name StateMachine
extends Node

@export
var starting_state: State
var current_state: State

# Initialize the state machine by giving each child state a reference to the
# parent object it belongs to and enter the default starting_state.
func init(actor: CharacterBody2D, mediator: Mediator, animations: AnimatedSprite2D, move_component: Node) -> void:
	for child in get_children():
		child.actor = actor
		child.animations = animations
		child.mediator = mediator
		# TODO: Remove these once the component manager is working
		child.move_component = move_component
		move_component.actor = actor
	change_state(starting_state)

# Change to the new state by first calling any exit logic on the current state.
func change_state(new_state: State) -> void:
	if current_state:
		current_state.exit()
	current_state = new_state
	current_state.enter()

# Pass through functions for the parent to call,
# handling state changes as needed.
func process_input(event: InputEvent) -> void:
	var new_state = current_state.process_input(event)
	if new_state:
		change_state(new_state)

func process_physics(delta: float) -> void:
	var new_state = current_state.process_physics(delta)
	if new_state:
		change_state(new_state)

func process_frame(delta: float) -> void:
	var new_state = current_state.process_frame(delta)
	if new_state:
		change_state(new_state)
