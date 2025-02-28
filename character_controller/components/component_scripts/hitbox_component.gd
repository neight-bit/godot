extends Component

@onready
var hitbox_shape: CollisionShape2D = $hitbox_area/hitbox_collider

func _ready() -> void:
	set_hitbox_enabled(false)
	actions = [
	]

func set_hitbox_enabled(enabled: bool) -> void:
	if hitbox_shape:
		hitbox_shape.set_deferred("disabled", not enabled)
