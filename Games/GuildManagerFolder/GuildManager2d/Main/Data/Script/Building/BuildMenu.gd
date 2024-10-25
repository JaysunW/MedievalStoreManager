extends CanvasLayer

@onready var parent_v_container = $PanelContainer/MarginContainer/ParentVContainer

@export var build_container : PackedScene

signal chose_building_option(String)

var container_list = []

func _ready():
	fill_container()

func show_building_options(input):
	visible = input

func fill_container():
	var building_data = Data.building_data
	for i in range(len(building_data)): 
			var new_container = build_container.instantiate()
			parent_v_container.add_child(new_container)
			new_container.get_pressed_signal().connect(chosen_container)
			new_container.set_container_info(i, building_data[i])

func chosen_container(pressed_container):
	show_building_options(false)
	chose_building_option.emit(pressed_container.content_data)
