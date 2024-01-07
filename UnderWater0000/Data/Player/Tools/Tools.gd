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
	var next_tool = Input.is_action_just_released("mouse_wheel_up")
	var previous_tool = Input.is_action_just_released("mouse_wheel_down")
	if next_tool:
		change_tool(1)
	elif previous_tool:
		change_tool(-1)
	if Input.is_action_just_released("q"):
		change_tool(1)
	if Input.is_action_just_released("e"):
		change_tool(-1)

func change_tool(change):
	current_tool_id = current_tool_id + change
	if current_tool_id < 0: current_tool_id = tool_list.size() - 1
	elif current_tool_id > tool_list.size() - 1: current_tool_id = 0
	for i in tool_list.size():
		tool_list[i].activate(i == current_tool_id)
		tool_list[i].visible = i == current_tool_id
