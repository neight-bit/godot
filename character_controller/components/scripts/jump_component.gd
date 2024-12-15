extends Component

@export
var max_jumps: int = 1

var remaining_jumps: int

func _ready():
	actions = [
		["wants_jump", self, [null]],
		["get_jump", self, ["pre_buffered"]],
		["reset_jumps", self, [null]],
	]

func wants_jump() -> bool:
	return Input.is_action_just_pressed('jump')

func get_jump(pre_buffered: bool = false) -> bool:
	"""The pre_buffered argument overrides forces wants_jump to true.
	This is because the call that evaluates a jump buffering request processes jump input several
	frames before get_jump is called.  By then the jump input not likely active anymore"""
	var char_wants_jump: bool
	char_wants_jump = true if pre_buffered else wants_jump()
	if actor.remaining_jumps <= 0:
		return false
	
	if actor.is_on_floor():
		#if parent.get('is_dashing') and parent.is_dashing:
			#if parent.can_jump_while_dashing:
				#return char_wants_jump
			#else:
				#return false
		
		return char_wants_jump
	
	else:
		#if parent.get('is_dashing') and parent.is_dashing:
			#if parent.can_jump_while_air_dashing:
				#return char_wants_jump
			#else:
				#return false
		return char_wants_jump

func reset_jumps() -> void:
	if actor.is_on_floor():
		remaining_jumps = max_jumps
