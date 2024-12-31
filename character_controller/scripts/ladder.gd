@tool
extends Node2D
class_name Ladder

@onready var ladder_bottom:			Sprite2D 			= $ladder_bottom
@onready var ladder_middle:			Sprite2D 			= $ladder_middle
@onready var ladder_top:			Sprite2D 			= $ladder_top
@onready var middle_container:		Node2D 				= $middle_container
@onready var ladder_main_area:		Area2D 				= $ladder_main_area
@onready var ladder_top_area:		Area2D 				= $ladder_top_area
@onready var pass_thru_platform:	StaticBody2D 		= $pass_thru_platform
@onready var _height: 				int
@onready var ladder_width:			int

@export
var height_in_tiles: int:
	get:
		return _height
	set(value):
		_height = value
		if ladder_bottom and ladder_top and middle_container and ladder_middle:
			update_ladder_dimensions(value)

func _ready():
	update_ladder_dimensions(_height)
	ladder_main_area.body_entered.connect(_on_body_entered_main_ladder_area)
	ladder_main_area.body_exited.connect(_on_body_exited_main_ladder_area)
	ladder_top_area.body_entered.connect(_on_body_entered_top_ladder_area)
	ladder_top_area.body_exited.connect(_on_body_exited_top_ladder_area)
	
func get_ladder_width() -> int:
	return ladder_middle.texture.get_size().x

func update_ladder_dimensions(new_height):
	ladder_width = get_ladder_width()
	_height = max(new_height, 1)
	update_visuals()
	update_collision_shape()
	set_platform_position()

func update_visuals():
	for child in middle_container.get_children():
		child.queue_free()
	var middle_piece_height = ladder_middle.texture.get_size().y

	for i in range(height_in_tiles-1): # Skip 1 to account for the bottom tile
		var middle_piece = ladder_middle.duplicate()
		middle_piece.position = Vector2(
			0,
			-ladder_bottom.position.y - ((i+1) * middle_piece_height) # Add 1 to start offset after bottom tile  
		)
		middle_piece.show()
		middle_container.add_child(middle_piece)

	ladder_top.position.y =  -get_bottom_height() - get_middle_height() + (get_top_height() /2.0)

func get_bottom_height() -> int:
	return ladder_bottom.texture.get_size().y

func get_middle_height() -> int:
	return ladder_middle.texture.get_size().y * (_height - 1)
	
func get_top_height() -> int:
	return ladder_top.texture.get_size().y

func get_total_height_in_pixels() -> int:
	return get_bottom_height() + get_middle_height() + get_top_height()

func update_collision_shape():
	$ladder_main_area/ladder_main_collider.shape.set_size(Vector2(ladder_width, get_bottom_height() + get_middle_height()))
	$ladder_main_area/ladder_main_collider.position.y = (get_bottom_height() + get_middle_height())/-2.0 + get_top_height()
	$ladder_top_area/ladder_top_collider.shape.set_size(Vector2(ladder_width, get_top_height()))
	$ladder_top_area/ladder_top_collider.position.y -= get_middle_height()

func _on_body_entered_main_ladder_area(body):
		var event = LadderDetectionEvent.new(body, self, true, 'main')
		EventBus.service().broadcast(event)

func _on_body_exited_main_ladder_area(body):
		var event = LadderDetectionEvent.new(body, self, false, 'main')
		EventBus.service().broadcast(event)

func _on_body_entered_top_ladder_area(body):
		var event = LadderDetectionEvent.new(body, self, true, 'top')
		EventBus.service().broadcast(event)

func _on_body_exited_top_ladder_area(body):
		var event = LadderDetectionEvent.new(body, self, false, 'top')
		EventBus.service().broadcast(event)

	
class LadderDetectionEvent extends Event:
	const id = "BODY_ON_LADDER_DETECTION"
	var body: CharacterBody2D
	var ladder: Ladder
	var is_on_ladder: bool
	var section: String # main, top
	
	func _init(actor_body: CharacterBody2D, ladder_instance: Ladder, on_ladder, ladder_section: String):
		super(id)
		self.body = actor_body
		self.ladder = ladder_instance
		self.is_on_ladder = on_ladder
		self.section = ladder_section
		
func set_platform_position():
	pass_thru_platform.get_child(0).shape.set_size(Vector2(ladder_width, 2))
	pass_thru_platform.position.y = -get_bottom_height() - get_middle_height() + get_top_height()

func get_pass_thru_platfrom():
	return pass_thru_platform
