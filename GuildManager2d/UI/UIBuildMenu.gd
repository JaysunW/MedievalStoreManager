extends CanvasLayer

signal chose_expanding_option
var container_list = []

func _ready() -> void:
	visible = false
	UI.open_build_UI.connect(show_building_options)

func show_building_options(input):
	visible = input
	
func _on_expand_button_button_down() -> void:
	show_building_options(false)
	SignalService.chose_expanding_option.emit()


func _on_remove_button_down() -> void:
	show_building_options(false)
	SignalService.chose_remove_structure.emit()
	pass # Replace with function body.


func _on_move_button_down() -> void:
	show_building_options(false)
	SignalService.chose_move_structure.emit()
	pass # Replace with function body.
