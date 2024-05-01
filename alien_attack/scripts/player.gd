extends CharacterBody2D

var speed = 350

var rocket_scene = preload("res://scenes/rocket.tscn")

@onready var ROCKET_CONTAINER = $RocketContainer
# Same as doing
# var ROCKET_CONTAINER
# def _ready():
#	ROCKET_CONTAINER = get_node("RocketContainer")

func _process(delta):
	if Input.is_action_just_pressed("shoot"):
		shoot()

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

func shoot():
	var rocket_instance = rocket_scene.instantiate()
	ROCKET_CONTAINER.add_child(rocket_instance)
	rocket_instance.global_position = global_position
	rocket_instance.global_position.x += 50
