extends CanvasLayer

var container_list = []
@onready var v_box_container = $PanelContainer/MarginContainer/VBoxContainer

signal chose_building_option(String)

func _ready():
	get_container_from_children()
	fill_container()
	print("filled")

func show_building_options(input):
	visible = input

func fill_container():
	var building_data = Data.building_data
	for i in range(len(container_list)): 
		if building_data.has(i):
			container_list[i].set_container_info(i, building_data[i])
		else:
			container_list[i].disable()

func get_container_from_children():
	for child in v_box_container.get_children():
		if child.has_method("get_container"):
			var pressed_signal = child.call("get_signal")
			pressed_signal.connect(chosen_container)
			container_list.append(child.call("get_container"))

func chosen_container(pressed_container):
	print(pressed_container.content_data)
	show_building_options(false)
	chose_building_option.emit(pressed_container.content_data["name"])
