extends Control

var license_data : Dictionary

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

var is_unlocked = false
var is_unlockable = false

signal pressed_button

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	panel_container.visible = false
	
func set_info(data):
	license_data = data
	license_icon.texture = Loader.shop_item_texture(data["sprite_path"])
	title.text = data["name"]
	parse_description(data["description"])
	
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

func _on_button_mouse_entered() -> void:
	panel_container.visible = true
	scale = Vector2(1.2,1.2)
	button_background.texture = hover_texture

func _on_button_mouse_exited() -> void:
	scale = Vector2(1,1)
	panel_container.visible = false
	button_background.texture = normal_texture

func _on_button_button_down() -> void:
	if not is_unlocked and is_unlockable:
		pressed_button.emit(self)
		button_background.texture = pressed_texture

func _on_button_button_up() -> void:
	if is_unlockable:
		button_background.texture = hover_texture
