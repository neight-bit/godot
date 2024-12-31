class_name Player
extends CharacterBody2D

@onready
var animations = $animations

@onready
var state_machine = $state_machine

@onready
var component_manager = $component_manager

@onready
var mediator = $mediator

func _ready() -> void:
	print("initializing player")
	component_manager.init(self, mediator)
	state_machine.init(self, mediator, animations)
	mediator.init(self, component_manager, state_machine)
	Utils.get_layer_by_name("ladders", "2d_physics")

func _unhandled_input(event: InputEvent) -> void:
	state_machine.process_input(event)
	
func _physics_process(delta: float) -> void:
	state_machine.process_physics(delta)

func _process(delta: float) -> void:
	state_machine.process_frame(delta)
