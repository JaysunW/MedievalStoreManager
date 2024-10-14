extends MarginContainer

@onready var icon = $MarginContainer/HBoxContainer/Icon
@onready var cost_label = $MarginContainer/HBoxContainer/Cost
@onready var name_label = $MarginContainer/HBoxContainer/Name
@onready var margin_container = $MarginContainer
@onready var button = $Button

var content_data
var id
signal pressed_button(MarginContainer)

func set_container_info(id, data):
	print("Data set", self.name)
	self.id = id
	content_data = data
	icon.texture = load(data["sprite_path"])
	cost_label.text = data["value"]
	name_label.text = data["name"]
	margin_container.visible = true
	button.visible = true

func get_signal():
	return pressed_button

func get_container():
	return self

func disable():
	pass

func _on_button_pressed():
	pressed_button.emit(self)
