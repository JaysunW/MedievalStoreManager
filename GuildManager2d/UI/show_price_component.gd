extends Control

@export_group("UI Elements")
@export var copper_icon : TextureRect
@export var silver_icon : TextureRect
@export var gold_icon : TextureRect
@export var copper_value_label : Label
@export var silver_value_label : Label
@export var gold_value_label : Label

func show_value(value):
	var copper_value = value % 1000
	if copper_value == 0:
		copper_icon.visible = false
		copper_value_label.visible = false
	else:
		copper_value_label.text = str(copper_value)
		copper_icon.visible = true
		copper_value_label.visible = true
	var silver_value = (value - copper_value) % 1000000
	if silver_value == 0:
		silver_icon.visible = false
		silver_value_label.visible = false
	else:
		silver_value_label.text = str(silver_value/1000)
		silver_icon.visible = true
		silver_value_label.visible = true
	var gold_value = (value - copper_value - silver_value) % 1000000000
	if gold_value == 0:
		gold_icon.visible = false
		gold_value_label.visible = false
	else:
		gold_value_label.text = str(gold_value/1000000) 
		gold_icon.visible = true
		gold_value_label.visible = true
