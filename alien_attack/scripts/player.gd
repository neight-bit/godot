extends CharacterBody2D

var speed = 350

func _physics_process(delta):

	velocity = Vector2(0, 0)
	if Input.is_action_pressed("move_right"):
		velocity.x = speed
	if Input.is_action_pressed("move_left"):
		velocity.x = -speed
	if Input.is_action_pressed("move_down"):
		velocity.y = speed
	if Input.is_action_pressed("move_up"):
		velocity.y = -speed

	var screen_size = get_viewport_rect().size
	
	global_position = global_position.clamp(Vector2(0,0), screen_size)
	move_and_slide()
