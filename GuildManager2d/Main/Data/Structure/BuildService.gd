extends Node2D

@export var navigation_region : NavigationRegion2D

@export_group("Children")
@export var placing_menu : Node2D
@export var expand_menu : Node2D
@export var remove_menu : Node2D
@export var move_menu : Node2D

var mouse_grid_offset = Vector2i(16,32)
var opened_menu = false
var active_child = null

func _ready() -> void:
	SignalService.chose_expanding_option.connect(enter_expand_menu)
	SignalService.chose_building_option.connect(enter_building_menu)
	SignalService.chose_remove_structure.connect(enter_remove_structure_menu)
	SignalService.chose_move_structure.connect(enter_move_structure_menu)

func _process(_delta):
	if Input.is_action_just_pressed("c"):
		Stock.print_current_stock()		
	if active_child:
		active_child.Process(_delta)
		return
	if Input.is_action_just_pressed("right_mouse"):
		if UI.get_set_ui_free():
			UI.open_build_UI.emit(true)
			opened_menu = true
			SignalService.restrict_player(true, false)
		elif opened_menu:
			opened_menu = false
			UI.is_free(true)
			UI.open_build_UI.emit(false)
			SignalService.restrict_player(false, false)
		
	
func update_navigation_region():
	navigation_region.call_deferred("bake_navigation_polygon")	

func child_exit():
	active_child = null
	UI.open_build_UI.emit(true)

func enter_expand_menu() -> void:
	active_child = expand_menu
	expand_menu.Enter()

func enter_building_menu(structure_data: Variant) -> void:
	active_child = placing_menu
	placing_menu.Enter(structure_data) 
	
func enter_remove_structure_menu() -> void:
	active_child = remove_menu
	remove_menu.Enter()

func enter_move_structure_menu() -> void:
	active_child = move_menu
	move_menu.Enter()
