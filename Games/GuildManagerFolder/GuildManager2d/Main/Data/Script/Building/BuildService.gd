extends Node2D

@export var navigation_region : NavigationRegion2D
@export var ui_build_menu : CanvasLayer

@export_group("Children")
@export var placing_menu : Node2D
@export var expand_menu : Node2D

var mouse_grid_offset = Vector2i(16,32)
var child_is_active = false

func _ready():
	ui_build_menu.visible = false

func _process(_delta):
	if Input.is_action_just_pressed("c"):
		Stock.print_current_stock()		
	if child_is_active:
		return
	if Input.is_action_just_pressed("right_mouse"):
		if UI.is_ui_free():
			change_build_mode(true)
		else:
			change_build_mode(false)
	
func update_navigation_region():
	navigation_region.call_deferred("bake_navigation_polygon")	

func change_build_mode(input):
	print_debug("What")
	ui_build_menu.visible = input
	UI.is_free(not input)

func child_exit():
	child_is_active = false
	ui_build_menu.visible = true

func _on_ui_build_menu_chose_expanding() -> void:
	child_is_active = true
	expand_menu.call_deferred("Enter") 

func _on_ui_build_menu_chose_building_option(stand_data: Variant) -> void:
	child_is_active = true
	placing_menu.call_deferred("Enter", stand_data) 
