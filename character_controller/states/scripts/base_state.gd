class_name State
extends Node

@export
var animation_name: String

var actor: CharacterBody2D
var animations: AnimatedSprite2D
var mediator: Mediator
var required_components: Array[String]
var optional_components: Array[String]

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