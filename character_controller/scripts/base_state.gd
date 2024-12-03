class_name State
extends Node

@export
var animation_name: String

@export
var move_speed: float = 300

var parent: CharacterBody2D
var animations: AnimatedSprite2D
var move_component: Node
var gravity : int = ProjectSettings.get_setting("physics/2d/default_gravity")

func enter() -> void:
	if animation_name:
		animations.play(animation_name)

func exit() -> void:
	pass
	
func process_input(event: InputEvent) -> State:
	return null

func process_physics(delta: float) -> State:
	return null

func process_frame(delta: float) -> State:
	return null
