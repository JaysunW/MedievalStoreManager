extends CanvasLayer

@onready var parent_v_container = $PanelContainer/MarginContainer/ParentVContainer

@export var build_container : PackedScene

signal chose_building_option(String)
signal chose_expanding

var container_list = []

func _ready() -> void:
	visible = false
	UI.open_build_UI.connect(show_building_options)
	SignalService.new_license_bought.connect(fill_container)
	fill_container_with_unlocked_item()

func show_building_options(input):
	visible = input
	
func fill_container_with_unlocked_item():
	var building_data = Data.building_data
	for id in range(len(building_data)): 
		if Global.is_license_unlocked([building_data[id]["store_area"]]):
			var new_container = build_container.instantiate()
			parent_v_container.add_child(new_container)
			new_container.get_pressed_signal().connect(chosen_container)
			new_container.set_container_info(id, building_data[id])

func fill_container(new_license):
	var building_data = Data.building_data
	for id in range(len(building_data)): 
		if building_data[id]["store_area"] == new_license:
			var new_container = build_container.instantiate()
			parent_v_container.add_child(new_container)
			new_container.get_pressed_signal().connect(chosen_container)
			new_container.set_container_info(id, building_data[id])

func chosen_container(pressed_container) -> void:
	show_building_options(false)
	chose_building_option.emit(pressed_container.container_data)

func _on_expand_button_button_down() -> void:
	show_building_options(false)
	
	chose_expanding.emit()
