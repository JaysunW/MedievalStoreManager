extends TabBar

@export var ui_build_menu : CanvasLayer
@export var scroll_parent : VBoxContainer
@export var build_container : PackedScene

signal chose_building_option(String)

var container_list = []

func _ready() -> void:
	SignalService.new_license_bought.connect(new_license_unlocked)
	fill_container_with_unlocks()

func new_license_unlocked():
	for container in container_list:
		container.queue_free()
	container_list.clear()
	fill_container_with_unlocks()
	
func fill_container_with_unlocks():
	var building_data = Data.building_data
	for id in range(len(building_data)): 
		if Global.is_license_unlocked([building_data[id]["store_area"]]):
			print("Added: ", building_data[id]["name"])
			var new_container = build_container.instantiate()
			scroll_parent.add_child(new_container)
			new_container.get_pressed_signal().connect(chosen_container)
			new_container.set_container_info(id, building_data[id])
			container_list.append(new_container)

func chosen_container(pressed_container) -> void:
	ui_build_menu.show_building_options(false)
	SignalService.chose_building_option.emit(pressed_container.container_data)