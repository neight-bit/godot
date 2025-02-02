class_name Actor
extends CharacterBody2D

@onready
var mediator: Mediator = $mediator

@onready
var state_machine = $state_machine

@onready
var component_manager: ComponentManager = $component_manager

func _ready() -> void:
	print("initializing player")
	component_manager.init(self, mediator)
	mediator.init(self, state_machine, component_manager )
	state_machine.init(self, mediator)
	print("player initialized")

func _unhandled_input(event: InputEvent) -> void:
	state_machine.process_input(event)
	
func _physics_process(delta: float) -> void:
	state_machine.process_physics(delta)

func _process(delta: float) -> void:
	state_machine.process_frame(delta)
