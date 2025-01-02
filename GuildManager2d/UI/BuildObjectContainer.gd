extends Control

@export var icon : TextureRect
@export var name_label : Label

@export_group("Display elements") 
@export var copper_value_label: Label
@export var silver_value_label: Label
@export var gold_value_label: Label
@export var copper_icon: TextureRect
@export var silver_icon: TextureRect
@export var gold_icon: TextureRect

signal pressed_button(MarginContainer)
var container_data
var id

func set_container_info(input_id, data):
	id = input_id
	container_data = data
	icon.texture = Loader.load_texture(data["sprite_path"])
	set_value(data["value"])
	name_label.text = data["name"]
	visible = true

func set_value(value):
	var label_list = [copper_value_label, silver_value_label, gold_value_label]
	var icon_list = [copper_icon, silver_icon, gold_icon]
	Global.set_value_display(value, label_list, icon_list)

func get_pressed_signal():
	return pressed_button

func get_container():
	return self

func _on_button_pressed():
	pressed_button.emit(self)
