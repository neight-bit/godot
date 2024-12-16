extends Node
class_name Component

@export
var enabled: bool = true

@export
var manager: ComponentManager

var mediator: Mediator

var actions: Array = []

var properties: Dictionary = {}

@export
var actor: Node2D

func reset():
	pass

func clean_up():
	queue_free()
	
