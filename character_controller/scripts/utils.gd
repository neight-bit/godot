extends Node

@onready var layer_group_names = [
	"2d_render", "2d_physics", "2d_navigation", \
	"3d_render", "3d_physics", "3d_navigation", \
	"avoidance"
]

@onready var _layers:= {}

func _ready():
	_generate_layers()

func _generate_layers():
	for group_name in layer_group_names:
		var layers = {}
		var layer_group_path = "layer_names/" + group_name + "/layer_"
		for i in range(1, 33):
			var layer_num_string = layer_group_path + str(i)
			var layer = ProjectSettings.get_setting(layer_num_string)
			if layer not in [null, ""]:
				layers[layer] = i
		_layers[group_name] = layers

func _validate_layer_group(group_name: String) -> void:
	assert(group_name in layer_group_names, group_name + " is not in: " + str(layer_group_names))

func get_layer_by_name(layer_name: String, group_name: String="2d_physics") -> int:
	_validate_layer_group(group_name)
	return _layers[group_name][layer_name]

func get_layers_by_group(group_name: String) -> Dictionary:
	_validate_layer_group(group_name)
	return _layers[group_name]

func get_layers() -> Dictionary:
	return _layers
