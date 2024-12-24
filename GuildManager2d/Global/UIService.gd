extends Node

@export var is_ui_open = true
@export var blocking_script : Node

signal set_ui_time(int)
signal set_ui_time_mode(String)

signal open_build_UI
signal open_item_menu_UI
signal open_license_menu_UI
signal open_stand_info_UI
signal open_expansion_UI
signal change_checkout_UI

signal picked_up_package(Dictionary)
signal flash_held_object(Color)

func is_ui_free():
	return is_ui_open

func is_free(input):
	is_ui_open = input
	
func get_set_ui_free():
	if is_ui_open:
		is_ui_open = false
		return true
	return false

#func set_ui(input):
	#is_ui_open = input
