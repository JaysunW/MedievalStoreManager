extends TextureButton

@export_category("Unlcok Settings")
@export var unlock_name : String 
@export var icon : Texture2D
@export var title_text : String
@export var description_text : String

@export_group("UI Objects")
@export var license_icon: TextureRect 
@export var panel_container: PanelContainer
@export var title: Label
@export var description: Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	panel_container.visible = false
	license_icon.texture = icon
	title.text = title_text
	parse_description(description_text)

func parse_description(text : String) -> void:
	var new_text : String = text.replace("...", "\n")
	description.text = new_text

func _on_mouse_entered() -> void:
	scale = Vector2(1.2,1.2)
	panel_container.visible = true

func _on_mouse_exited() -> void:
	scale = Vector2(1,1)
	panel_container.visible = false
