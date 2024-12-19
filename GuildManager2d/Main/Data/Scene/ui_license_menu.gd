extends CanvasLayer

@export var license_menu_parent : Control

var button_list = []

func _ready() -> void:
	visible = false
	update_license_tree(true)
	UI.open_license_menu_UI.connect(show_license_menu)
	
func check_button(pressed_button):
	var license_data = pressed_button.license_data
	#TODO: Check the money whether its enough

	if is_license_data_unlockable(license_data):
		pressed_button.unlock()
		Data.player_data["license"].append(license_data["name"])
		update_license_tree()
		
func is_license_data_unlockable(license_data):
	var upgrades_needed = parse_license_unlocked_by(license_data["unlocked_by"])
	var unlocked_licenses = Data.player_data["license"]
	return is_subset(upgrades_needed, unlocked_licenses)

func is_license_data_unlocked(license_data):
	var license_name = parse_license_unlocked_by(license_data["name"])
	var unlocked_licenses = Data.player_data["license"]
	return is_subset(license_name, unlocked_licenses)

func is_subset(list_a: Array, list_b: Array) -> bool:
	for item in list_a:
		if item not in list_b:
			return false	
	return true
	
func update_license_tree(connect_button = false):
	var license_data = Data.license_data
	var child_count = license_menu_parent.get_child_count()
	for i in range(child_count):
		var child = license_menu_parent.get_child(i)
		if i < len(license_data):
			var data = license_data[i]
			button_list.append(child)
			if connect_button:
				child.pressed_button.connect(check_button)
			child.set_info(data)
			if is_license_data_unlocked(data):
				child.unlock()
			elif is_license_data_unlockable(data):
				child.unlockable()
		else:
			child.hide_button()
	
func parse_license_unlocked_by(input):
	var output = input.split(",")
	if output[0] == "":
		return []
	return output
	
func show_license_menu():
	visible = true

func _on_return_button_down() -> void:
	UI.is_free(true)
	visible = false
