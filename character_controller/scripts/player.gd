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

@export 
var can_dash: bool = true

@export
var can_air_dash: bool = true

@export
var can_jump_while_dashing: bool = true

@export
var can_jump_while_air_dashing: bool = true

@export
var max_jumps: int = 1

@export_range(0.0, 5000, 1) var acceleration_factor: float = 0.0

var orientation: float:
	get:
		return orientation if orientation else 1.0
	set(value):
		if value < 0:
			self.animations.flip_h = true
			orientation = value
		if value > 0:
			self.animations.flip_h = false
			orientation = value
		if value == 0:
			# don't flip the sprite's direction
			pass

var remaining_jumps: int = max_jumps

var is_dashing = false

func _ready() -> void:
	state_machine.init(self, animations, move_component)

func _unhandled_input(event: InputEvent) -> void:
	state_machine.process_input(event)
	
func _physics_process(delta: float) -> void:
	state_machine.process_physics(delta)
	
func _process(delta: float) -> void:
	state_machine.process_frame(delta)
