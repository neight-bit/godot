extends Control

@onready var texture = load("res://assets/textures/player_ship.png")

@onready var lives_container = $LivesContainer

func update_lives(num: int) -> void:
	for child in lives_container.get_children():
		child.queue_free()
		
	for i in range(num):
		var texture_rect = TextureRect.new()
		texture_rect.texture = texture
		texture_rect.expand_mode = TextureRect.EXPAND_FIT_WIDTH_PROPORTIONAL
		lives_container.add_child(texture_rect)
