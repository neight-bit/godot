extends Component

@onready
var animation_base_offsets := {}

@onready
var animation_wrapper: Node2D = $animation

@onready
var animation_player: AnimationPlayer = $animation/animation_player

@onready
var sprites: Sprite2D = $animation/sprites

func _ready() -> void:
	print("Initializing Renderer component")
	register_offsets()
	EventBus.service().subscribe("ActorOrientationEvent", self, "OnActorOrientationEvent")
	actions = [
		["get_current_animation", 			self, {}],
		["get_base_offset",					self, {"animation_name": "RESET"}],
		["get_animation_player",			self, {}],
		["register_offsets", 				self, {}],
		["animation_flip_h", 				self, {"value": false}],
		["set_animation_orientation",		self, {"value": 0}],
		["update_animation_orientation",	self, {"value": 0}],
		["flip_animation_X_offset",			self, {"value": 0}],
		["play_animation",					self, {"animation_name": ""}]
	]

func play_animation(animation_name: String) -> void:
	var orientation = mediator.request("get_orientation")
	if orientation and orientation < 1:
		flip_animation_X_offset(orientation, animation_name)
	animation_player.play(animation_name)


func register_offsets() -> void:
	"""A registry of the sprite offset (Vector2) for each animation
	This is useful if we want to flip the sprite, since we have both mirror the image, 
	but also its position relative to the parent node"""  
	for animation_name in animation_player.get_animation_list():
		var animation = animation_player.get_animation(animation_name)
		for track_index in animation.get_track_count():
			var property_path = animation.track_get_path(track_index)
			if str(property_path).ends_with("sprites:offset"):
				if ! animation_base_offsets.has(animation_name):
					animation_base_offsets[animation_name] = animation.track_get_key_value(track_index, 0)
				break
	print("Animation offsets: " + str(animation_base_offsets))

func OnActorOrientationEvent(event: Event) -> void:
	if event.actor == actor:
		update_animation_orientation(event.orientation)

func get_base_offset(animation_name: String):
	if animation_base_offsets.has(animation_name):
		return animation_base_offsets[animation_name]
	return null

func get_animation_player() -> AnimationPlayer:
	return animation_player

func get_current_animation() -> String:
	return animation_player.current_animation

func animation_flip_h(value: bool) -> void:
	sprites.flip_h = value

func update_animation_orientation(value: int):
	set_animation_orientation(value)
	flip_animation_X_offset(value)

func set_animation_orientation(value: int) -> void:
	if value < 0:
		sprites.flip_h = true
	elif value > 0:
		sprites.flip_h = false
	else:
		pass

func flip_animation_X_offset(value, animation_name: String="") -> void:
	if not animation_name:
		animation_name = get_current_animation()
	var offset = get_base_offset(animation_name)
	if offset:
		if value == 1:
			animation_wrapper.position.x = 0
		elif value == -1:
			animation_wrapper.position.x = -2 * offset.x
