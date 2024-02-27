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
	var tool_data = LoadoutService.get_tool_stats()
	for laser in tool_data["laser"]:
		print(laser["sprite_path"])
		add_container(0, load(laser["sprite_path"]), laser, laser["price"])
	for knife in tool_data["knife"]:
		add_container(1, load(knife["sprite_path"]), knife, knife["price"])
	for net in tool_data["net"]:
		add_container(2, load(net["sprite_path"]), net, net["price"])

# when adding new belts change the other!
func add_container(belt_nr, sprite, data, prize, unlocked = true):
	var new_container = showcase_scene.instantiate()
	belts[belt_nr].add_child(new_container)
	new_container.position = Vector2(32 * belt_item_list[belt_nr].size(),0)
	new_container.set_data(data)
	new_container.set_sprite(sprite)
	new_container.set_prize(prize)
	new_container.get_select_signal().connect(_item_selected)
	new_container.get_deselect_signal().connect(_item_deselected)
	if not unlocked: new_container.set_locked()
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
