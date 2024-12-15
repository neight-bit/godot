class_name Player
extends CharacterBody2D

@onready
var animations = $animations

@onready
var state_machine = $state_machine

@onready
var component_manager = $component_manager

@onready
var move_component = $move_component

@onready
var mediator = $mediator


#region abilities
# For now, whether or not a character has *access* to a certain feature is defined here
# The various values for these features are defined in the downstream component(s)
# I think that there is a solid rationale for inheriting access through the components,
# but that requires a lot more thought and planning.
@export
var has_acceleration: bool = true

@export 
var can_dash: bool = true

@export
var can_air_dash: bool = true

@export
var can_jump_while_dashing: bool = true

@export
var can_jump_while_air_dashing: bool = true

@export 
var can_buffer_jumps: bool = true

@export
var max_jumps: int = 1

@export_range(0.0, 5000, 1) var acceleration_factor: float = 0.0
#endregion

var remaining_jumps: int = max_jumps

var is_dashing = false

func _ready() -> void:
	component_manager.init(self, mediator)
	state_machine.init(self, mediator, animations)
	mediator.init(self, component_manager, state_machine)

func _unhandled_input(event: InputEvent) -> void:
	state_machine.process_input(event)
	
func _physics_process(delta: float) -> void:
	state_machine.process_physics(delta)
	
func _process(delta: float) -> void:
	state_machine.process_frame(delta)
