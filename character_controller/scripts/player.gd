class_name Player
extends CharacterBody2D

@onready
var animations = $animations

@onready
var state_machine = $state_machine

@onready
var move_component = $move_component

@export
var has_acceleration: bool = true

@export_range(0.0, 5000, 1) var acceleration_factor: float = 0.0

func _ready() -> void:
	state_machine.init(self, animations, move_component)

func _unhandled_input(event: InputEvent) -> void:
	state_machine.process_input(event)
	
func _physics_process(delta: float) -> void:
	state_machine.process_physics(delta)
	
func _process(delta: float) -> void:
	state_machine.process_frame(delta)
