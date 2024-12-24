extends Control

@export var item_icon : TextureRect
@export var item_amount_label : Label

@export var gold_icon : TextureRect
@export var gold_value_label : Label 
@export var silver_icon : TextureRect 
@export var silver_value_label : Label
@export var copper_icon : TextureRect 
@export var copper_value_label : Label

var container_data
var id
var amount = 1
signal pressed_button(MarginContainer)

func set_container_info(input_id, data):
	set_value(data["market_value"] * data["amount"])
	id = input_id
	container_data = data
	item_icon.texture = Loader.shop_item_texture(data["sprite_path"])
	item_amount_label.text = str(amount)
	visible = true

func set_value(value):
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

func get_pressed_signal():
	return pressed_button

func get_container():
	return self

func disable():
	pass

func update_amount():
	set_value(container_data["market_value"] * container_data["amount"] * amount)
	item_amount_label.text = str(amount)

func add_amount(input):
	amount += input 
	update_amount()
	
func _on_delete_button_up() -> void:
	amount -= 1 
	update_amount()
	pressed_button.emit(self)
