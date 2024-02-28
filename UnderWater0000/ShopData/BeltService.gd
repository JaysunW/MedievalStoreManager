extends Sprite2D

@export var belt_speed = 50
@export var showcase_scene : PackedScene

var belt_item_list = []
var belts = []
var move_list = [0,0,0,0]
var move_dir = 0

func _ready():
	for child in $Clipping.get_children():
		belts.append(child)
		belt_item_list.append([])
	add_every_laser()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	for belt in belts:
		belt.position += Vector2.LEFT * move_dir * delta * belt_speed

func add_every_laser():
	var tool_data = LoadoutService.get_tool_data()
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

func _on_green_button_down():
	move_dir = 1

func _on_green_button_up():
	move_dir = 0

func _on_red_button_down():
	move_dir = -1

func _on_red_button_up():
	move_dir = 0
