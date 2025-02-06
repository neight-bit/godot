class_name StateMachine
extends Node

var current_state: State
var states: Dictionary = {"null": null}

# Initialize the state machine, giving each child state a reference to
# Some resources that they will need
func init(actor: CharacterBody2D, mediator: Mediator) -> void:
	print("initializing state machine")
	var animation_player = mediator.request("get_animation_player")
	for state in actor.states.values():
		states[state.name] = state
		state.state_machine = self
		state.actor = actor
		state.animation_player = animation_player
		state.mediator = mediator
	print("State machine initialized, setting initial state.")
	change_state(actor.states.get(actor.starting_state))

func get_state(state_name: String) -> State:
	if state_name in states:
		return states[state_name]
	return null

# Change to the new state by first calling any exit logic on the current state.
func change_state(new_state: State) -> void:
	print("current_state: " + str(current_state))
	print("new_state: " + str(new_state))
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
