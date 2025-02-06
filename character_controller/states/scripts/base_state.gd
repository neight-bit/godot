class_name State
extends Node

@export
var animation_name: String
var animation_player: AnimationPlayer
var actor: CharacterBody2D
var mediator: Mediator
var state_machine: StateMachine

func get_state(state_name):
	return state_machine.get_state(state_name)

func enter() -> void:
	if not animation_name:
		animation_name = self.name
	if animation_name and animation_player:
		animation_player.play(animation_name)

func exit() -> void:
	pass
	
func process_input(event: InputEvent) -> State:
	return null

func process_physics(delta: float) -> State:
	return null

func process_frame(delta: float) -> State:
	return null
