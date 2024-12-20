extends Control


@export_group("Button Images")
@export var normal_texture : Texture2D
@export var hover_texture : Texture2D
@export var pressed_texture : Texture2D
@export var lock_closed : Texture2D
@export var lock_open : Texture2D

@export_group("UI Objects")
@export var unlocked_crown : TextureRect
@export var license_icon : TextureRect 
@export var button_background : TextureRect
@export var lock_icon : TextureRect
@export var panel_container : PanelContainer
@export var title : Label
@export var description : Label
@export var price_component : Control

var license_data : Dictionary
var line_dictionary : Dictionary = {}
var is_unlocked = false
var is_unlockable = false

signal pressed_button

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	panel_container.visible = false
	price_component.visible = false
	
func set_info(data, other_position_dic):
	license_data = data
	license_icon.texture = Loader.shop_item_texture(data["sprite_path"])
	title.text = data["name"]
	price_component.show_value(data["value"])
	parse_description(data["description"])
	for type in data["unlocked_by"]:
		var other_position = other_position_dic[type]
		var line_connection = Line2D.new()
		line_dictionary[type] = line_connection
		line_connection.points = [Vector2i(32,32), other_position - position + Vector2(32,32)]
		add_child(line_connection)
	
func update_lines():
	for type in Data.player_data["license"]:
		if type in line_dictionary.keys():
			line_dictionary[type].modulate = Color(0,1,0)

func hide_button():
	visible = false
	
func unlock():
	lock_icon.visible = false
	unlocked_crown.visible = true
	is_unlocked = true
	
func unlockable():
	lock_icon.texture = lock_open
	button_background.material = null
	is_unlockable = true

func parse_description(text : String) -> void:
	var new_text : String = text.replace("...", "\n")
	description.text = new_text

func scale_icon(new_size):
	license_icon.scale = Vector2(new_size,new_size)
	button_background.scale = Vector2(new_size,new_size)
	lock_icon.scale = Vector2(new_size,new_size)

func _on_button_mouse_entered() -> void:
	scale_icon(1.7)
	price_component.visible = true
	panel_container.visible = true
	button_background.texture = hover_texture

func _on_button_mouse_exited() -> void:
	scale_icon(1.5)
	panel_container.visible = false
	price_component.visible = false
	button_background.texture = normal_texture

func _on_button_button_down() -> void:
	if not is_unlocked and is_unlockable:
		pressed_button.emit(self)
		button_background.texture = pressed_texture

func _on_button_button_up() -> void:
	if is_unlockable:
		button_background.texture = hover_texture
