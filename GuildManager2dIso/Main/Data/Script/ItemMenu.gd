extends CanvasLayer

@onready var parent_v_container = $PanelContainer/MarginContainer/ParentVContainer

@export var item_container : PackedScene

signal chose_building_option(String)

var container_list = []

func _ready():
	fill_container()

func show_building_options(input):
	visible = input

func fill_container():
	var item_data = Data.item_data
	for i in range(len(item_data)):
			if item_data[i]["unlocked"]:
				var new_container = item_container.instantiate()
				parent_v_container.add_child(new_container)
				new_container.get_pressed_signal().connect(chosen_container)
				new_container.set_container_info(i, item_data[i])

func chosen_container(pressed_container):
	show_building_options(false)
	chose_building_option.emit(pressed_container.content_data)
