extends Component

@onready
var animation_base_offsets := {}

@onready
var animation_player: AnimationPlayer = $animation_player

@onready
var animations: Sprite2D = $animations

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
		["flip_animation_X_offset",			self, {"value": 0}]
	]

func register_offsets() -> void:
	"""A registry of the sprite offset (Vector2) for each animation
	This is useful if we want to flip the sprite, since we have both mirror the image, 
	but also its position relative to the parent node"""  
	for animation_name in animation_player.get_animation_list():
		var animation = animation_player.get_animation(animation_name)
		for track_index in animation.get_track_count():
			var property_path = animation.track_get_path(track_index)
			if str(property_path).ends_with("animations:offset"):
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
	animations.flip_h = value

func update_animation_orientation(value: int):
	set_animation_orientation(value)
	flip_animation_X_offset(value)

func set_animation_orientation(value: int) -> void:
	if value < 0:
		animations.flip_h = true
	elif value > 0:
		animations.flip_h = false
	else:
		pass

func flip_animation_X_offset(value) -> void:
	var animation_names: Array = animation_player.get_animation_list()
	for animation_name in animation_names:
		var animation: Animation = animation_player.get_animation(animation_name)
		var track_index = animation.find_track("animations:offset", Animation.TYPE_VALUE)
		if track_index != -1:
			var offset_value = animation.track_get_key_value(track_index, 0)
			var base_offset: Vector2 = get_base_offset(animation_name)
			if value == 1:
				offset_value.x = base_offset.x
			elif value == -1:
				offset_value.x = -base_offset.x
			animation.track_set_key_value(track_index, 0, offset_value)
