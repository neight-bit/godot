extends Component

func _ready():
	actions = []

func _unhandled_input(event: InputEvent) -> void:
	mediator.request("set_movement_direction",	[Input.get_axis('move_left', 'move_right')])
	mediator.request("set_wants_jump",			[Input.is_action_just_pressed('jump')])
	mediator.request("set_wants_dash",			[Input.is_action_just_pressed('dash')])
	mediator.request("set_wants_attack",		[Input.is_action_just_pressed("attack")])
