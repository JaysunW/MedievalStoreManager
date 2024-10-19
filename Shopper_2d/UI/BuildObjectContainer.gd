extends MarginContainer

@onready var icon = $MarginContainer/HBoxContainer/Icon
@onready var name_label = $MarginContainer/HBoxContainer/Name

@onready var gold_icon = $MarginContainer/HBoxContainer/ValueGrid/GoldIcon
@onready var gold_value_label = $MarginContainer/HBoxContainer/ValueGrid/GoldValueLabel
@onready var silver_icon = $MarginContainer/HBoxContainer/ValueGrid/SilverIcon
@onready var silver_value_label = $MarginContainer/HBoxContainer/ValueGrid/SilverValueLabel
@onready var copper_icon = $MarginContainer/HBoxContainer/ValueGrid/CopperIcon
@onready var copper_value_label = $MarginContainer/HBoxContainer/ValueGrid/CopperValueLabel

@onready var build_object_container = $"."


var content_data
var id
signal pressed_button(MarginContainer)

func set_container_info(input_id, data):
	id = input_id
	content_data = data
	icon.texture = load(data["sprite_path"])
	set_value(data["value"])
	name_label.text = data["name"]
	build_object_container.visible = true

func set_value(value):
	var copper_value = value % 1000
	if copper_value == 0:
		copper_icon.visible = false
		copper_value_label.visible = false
	else:
		copper_value_label.text = str(copper_value)
	var silver_value = (value - copper_value) % 1000000
	if silver_value == 0:
		silver_icon.visible = false
		silver_value_label.visible = false
	else:
		silver_value_label.text = str(silver_value/1000)
	var gold_value = (value - copper_value - silver_value) % 1000000000
	if gold_value == 0:
		gold_icon.visible = false
		gold_value_label.visible = false
	else:
		gold_value_label.text = str(gold_value/1000000) 

func get_pressed_signal():
	return pressed_button

func get_container():
	return self

func disable():
	pass

func _on_button_pressed():
	pressed_button.emit(self)
