extends Node2D

var tool_list = []
var current_tool_id = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	for child in get_children():
		tool_list.append(child)
	change_tool(0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	look_at(get_global_mouse_position())

func change_tool(change):
	current_tool_id = current_tool_id + change
	if current_tool_id < 0: current_tool_id = tool_list.size() - 1
	elif current_tool_id > tool_list.size() - 1: current_tool_id = 0
	for i in tool_list.size():
		tool_list[i].visible = i == current_tool_id

func change_tool_sprite(type, sprite):
	pass
#	match type:
#		Enums.Tool.KNIFE:
#
#			# change sprite
#		Enums.Tool.LASER:
#			#change sprite
#		Enums.Tool.NET:
			# change sprite
