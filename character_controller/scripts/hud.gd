extends Control

@export var character: CharacterBody2D

func _ready():
	for child in get_children():
		child.character = character
