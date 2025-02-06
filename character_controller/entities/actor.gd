class_name Actor
extends CharacterBody2D

@export
var actor_name: String

@onready
var mediator: Mediator = $mediator

@onready
var component_manager: ComponentManager = $component_manager
@onready
var components = $components

@onready
var state_machine = $state_machine
@onready
var states: Dictionary = {}
@export
var starting_state: String


func _ready() -> void:
	print("initializing actor: " + actor_name )
	_load_states()
	component_manager.init(self, mediator)
	mediator.init(self, state_machine, component_manager )
	state_machine.init(self, mediator)
	print(actor_name + " player initialized")

func _unhandled_input(event: InputEvent) -> void:
	state_machine.process_input(event)
	
func _physics_process(delta: float) -> void:
	state_machine.process_physics(delta)

func _process(delta: float) -> void:
	state_machine.process_frame(delta)

func _load_states() -> void:
	var actor_states = $states
	for state in actor_states.get_children():
		states[state.name] = state
