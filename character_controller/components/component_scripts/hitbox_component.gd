extends Component

@onready
var hitbox_collision_shape: CollisionShape2D = $hitbox_collision_area/hitbox_collision_shape

@onready
var hitbox_collision_area: Area2D = $hitbox_collision_area

var base_offset: float

func _ready() -> void:
	set_hitbox_enabled(false)
	base_offset = hitbox_collision_shape.position.x
	actions = [
		["set_hitbox_enabled",			self, {"enabled": false}],
		["update_hitbox_orientation",	self, {"value": 1}]
	]

func set_hitbox_enabled(enabled: bool) -> void:
	if hitbox_collision_shape:
		print("Setting hitbox: " + str(enabled))
		hitbox_collision_shape.set_deferred("disabled", not enabled)

func update_hitbox_orientation(value: int) -> void:
	print("setting hitbox orientation")
	hitbox_collision_area.scale.x *= value
		
func print_scale_pos():
	print(hitbox_collision_area.scale)
	print(hitbox_collision_area.position.x)
