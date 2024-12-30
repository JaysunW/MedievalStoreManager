extends MarginContainer

@export_group("Paid UI Elements")
@export var paid_copper_value_label: Label
@export var paid_silver_value_label: Label
@export var paid_gold_value_label: Label
@export var paid_copper_icon: TextureRect
@export var paid_silver_icon: TextureRect
@export var paid_gold_icon: TextureRect

@export_group("Value UI Elements")
@export var value_copper_value_label: Label
@export var value_silver_value_label: Label
@export var value_gold_value_label: Label
@export var value_copper_icon: TextureRect
@export var value_silver_icon: TextureRect
@export var value_gold_icon: TextureRect

@export_group("Change UI Elements")
@export var change_copper_value_label: Label
@export var change_silver_value_label: Label
@export var change_gold_value_label: Label
@export var change_copper_icon: TextureRect
@export var change_silver_icon: TextureRect
@export var change_gold_icon: TextureRect

@export_group("Current Change UI Elements")
@export var current_copper_value_label: Label
@export var current_silver_value_label: Label
@export var current_gold_value_label: Label
@export var current_copper_icon: TextureRect
@export var current_silver_icon: TextureRect
@export var current_gold_icon: TextureRect

func reset():
	set_paid_display(0)
	set_value_display(0)
	set_change_display(0)
	set_current_display(0)

func set_paid_display(value):
	var label_list = [paid_copper_value_label,paid_silver_value_label,paid_gold_value_label]
	var icon_list = [paid_copper_icon, paid_silver_icon, paid_gold_icon]
	Global.set_value_display(value, label_list, icon_list)
	
func set_value_display(value):
	var label_list = [value_copper_value_label,value_silver_value_label,value_gold_value_label]
	var icon_list = [value_copper_icon, value_silver_icon, value_gold_icon]
	Global.set_value_display(value, label_list, icon_list)
	
func set_change_display(value):
	var label_list = [change_copper_value_label,change_silver_value_label,change_gold_value_label]
	var icon_list = [change_copper_icon, change_silver_icon, change_gold_icon]
	Global.set_value_display(value, label_list, icon_list)
	
func set_current_display(value):
	var label_list = [current_copper_value_label,current_silver_value_label,current_gold_value_label]
	var icon_list = [current_copper_icon, current_silver_icon, current_gold_icon]
	Global.set_value_display(value, label_list, icon_list)
