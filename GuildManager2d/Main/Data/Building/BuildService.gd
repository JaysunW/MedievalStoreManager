extends Node2D

@export var navigation_region : NavigationRegion2D

@export_group("Children")
@export var placing_menu : Node2D
@export var expand_menu : Node2D

var mouse_grid_offset = Vector2i(16,32)
var opened_menu = false
var child_is_active = false

func _process(_delta):
	if Input.is_action_just_pressed("c"):
		Stock.print_current_stock()		
	if child_is_active:
		return
	if Input.is_action_just_pressed("right_mouse"):
		if UI.get_set_ui_free():
			UI.open_build_UI.emit(true)
			opened_menu = true
			SignalService.restrict_player(true, false)
		else:
			if opened_menu:
				opened_menu = false
				UI.is_free(true)
				UI.open_build_UI.emit(false)
				SignalService.restrict_player(false, false)
	
func update_navigation_region():
	navigation_region.call_deferred("bake_navigation_polygon")	

func child_exit():
	child_is_active = false
	UI.open_build_UI.emit(true)

func _on_ui_build_menu_chose_expanding() -> void:
	child_is_active = true
	expand_menu.Enter()

func _on_ui_build_menu_chose_building_option(stand_data: Variant) -> void:
	child_is_active = true
	placing_menu.Enter(stand_data) 
