extends CanvasLayer

@export var license_menu_parent : Control

var button_list = []

func _ready() -> void:
	visible = false
	update_license_tree(true)
	UI.open_license_menu_UI.connect(show_license_menu)
	
func check_button(pressed_button):
	var license_data = pressed_button.license_data
	if pressed_button.is_unlockable:
		if Gold.pay(license_data["value"]):
			pressed_button.unlock()
			Data.player_data["license"].append(license_data["name"])
			update_license_tree()
			SignalService.new_license_bought.emit(license_data["name"])
		
func update_license_tree(first_update = false):
	var license_data = Data.license_data
	var child_count = license_menu_parent.get_child_count()
	var position_dic = {}
	for i in range(child_count):
		var child = license_menu_parent.get_child(i)
		if i < len(license_data):
			var data = license_data[i]
			position_dic[data["name"]] = child.position
			if first_update:
				button_list.append(child)
				child.pressed_button.connect(check_button)
				child.set_info(data, position_dic)
			child.update_lines()
			if Global.is_license_unlocked([data["name"]]):
				child.unlock()
			elif Global.is_license_unlocked(data["unlocked_by"]):
				child.unlockable()
		else:
			child.hide_button()

func show_license_menu():
	visible = true

func _on_return_button_down() -> void:
	UI.is_free(true)
	visible = false
