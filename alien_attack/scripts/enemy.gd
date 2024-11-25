extends Area2D

signal enemy_died

@export var speed = 300

@onready var visible_notifier = $EnemyVisibleNotifier

func _physics_process(delta):
	global_position.x += -speed*delta

func die():
	queue_free()

func _on_body_entered(body):
	body.take_damage()
	die()
