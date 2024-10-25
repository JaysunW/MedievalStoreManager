extends Sprite2D

@export var belt_speed = 50
@export var showcase_scene : PackedScene

var belt_item_list = []
var belts = []
var move_list = [0,0,0,0]
var start_x_position = 0
var button_pressed = false
var current_button = 0

func _ready():
	for child in $Clipping.get_children():
		belts.append(child)
		belt_item_list.append([])
		start_x_position = child.position.x
	add_every_upgrade()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if button_pressed:
		var i = current_button
		var current_position = belts[i].position
		var end_x_position = start_x_position + 32 * (belt_item_list[i].size() - 3)
		var diff_x_position = end_x_position - start_x_position
		var delta_x = clamp(current_position.x - 1 * move_list[i] * delta * belt_speed, start_x_position - diff_x_position, end_x_position - diff_x_position)
		belts[i].position = Vector2( delta_x, current_position.y)
		
func add_every_upgrade():
	var tool_data = DataService.get_tool_data()
	for i in range(tool_data.size()):
		var key_list = tool_data.keys()
		for tool in tool_data[key_list[i]]:
			add_container(i, tool)

func add_container(belt_nr, data):
	var new_container = showcase_scene.instantiate()
	belts[belt_nr].add_child(new_container)
	new_container.position = Vector2(32 * belt_item_list[belt_nr].size(),0)
	new_container.set_container(data)
	new_container.get_select_signal().connect(_item_selected)
	new_container.get_deselect_signal().connect(_item_deselected)
	belt_item_list[belt_nr].append(new_container)

func _item_selected(data, container):
	# Select Item
	$"../../..".buy_item(data, container)
	pass
	
func _item_deselected():
	# Deselect Item
	pass

func _on_green_button_down(input):
	move_list[input] = 1
	current_button = input
	button_pressed = true

func _on_green_button_up():
	move_list = [0,0,0,0]
	button_pressed = false

func _on_red_button_down(input):
	move_list[input] = -1
	current_button = input
	button_pressed = true

func _on_red_button_up():
	move_list = [0,0,0,0]
	button_pressed = false
