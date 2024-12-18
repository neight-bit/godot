class_name State
extends Node

@export
var animation_name: String

@export
var friction: float = 50

var parent: CharacterBody2D
var animations: AnimatedSprite2D
var move_component: Node
var direction: float

func enter() -> void:
	if animation_name and animations:
		animations.play(animation_name)

func exit() -> void:
	pass
	
func process_input(event: InputEvent) -> State:
	return null

func process_physics(delta: float) -> State:
	return null

func process_frame(delta: float) -> State:
	return null
	
func get_movement_direction():
	if move_component:
		return move_component.get_movement_direction()
	return 0
