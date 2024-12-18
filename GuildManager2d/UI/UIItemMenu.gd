extends CanvasLayer

@onready var item_store_parent = $ItemStore/MarginContainer/VBoxContainer/ItemStoreParent
@onready var checkout_parent = $ItemCheckout/VBoxContainer/MarginContainer/ScrollContainer/CheckoutParent

@onready var gold_icon = $ItemCheckout/VBoxContainer/ValueGrid/GoldIcon
@onready var gold_value_label = $ItemCheckout/VBoxContainer/ValueGrid/GoldValueLabel
@onready var silver_icon = $ItemCheckout/VBoxContainer/ValueGrid/SilverIcon
@onready var silver_value_label = $ItemCheckout/VBoxContainer/ValueGrid/SilverValueLabel
@onready var copper_icon = $ItemCheckout/VBoxContainer/ValueGrid/CopperIcon
@onready var copper_value_label = $ItemCheckout/VBoxContainer/ValueGrid/CopperValueLabel

@export var item_container : PackedScene
@export var item_checkout_container : PackedScene

signal spawn_bought_items(Dictionary)

var container_list = []

var checkout_list = {}

func _ready():
	fill_container()
	visible = false

func fill_container():
	var item_data = Data.item_data
	for i in range(len(item_data)):
		i = item_data.keys()[i]
		if item_data[i]["unlocked"]:
			var new_container = item_container.instantiate()
			item_store_parent.add_child(new_container)
			new_container.get_pressed_signal().connect(chosen_container)
			new_container.set_container_info(i, item_data[i])

func clear_checkout():
	set_checkout_value(0)
	checkout_list = {}
	for container in container_list:
		container.queue_free()
	container_list = []

func chosen_container(pressed_container):
	var id = pressed_container.id
	var checkout_prize = checkout_gold_total(pressed_container.container_data)
	if Gold.has_enough_gold(checkout_prize):
		if id in checkout_list.keys():
			checkout_list[id] += 1
			for container in container_list:
				if container.id == id:
					container.add_amount(1)
		else:
			var new_checkout_container = item_checkout_container.instantiate()
			checkout_parent.add_child(new_checkout_container)
			container_list.append(new_checkout_container)
			checkout_list[id] = 1
			new_checkout_container.get_pressed_signal().connect(delete_checkout_item)
			new_checkout_container.set_container_info(id,pressed_container.container_data)
		set_checkout_value(checkout_prize)
				
func checkout_gold_total(container_data= null):
	var item_data = Data.item_data
	var checkout_value = 0
	for key in checkout_list.keys():
		checkout_value += item_data[key]["market_value"] * item_data[key]["amount"]* checkout_list[key]
	if container_data:
		checkout_value += container_data["market_value"] * container_data["amount"]
	return checkout_value
		
func delete_checkout_item(pressed_container):
	var id = pressed_container.id
	checkout_list[id] -= 1
	set_checkout_value(checkout_gold_total())
	if checkout_list[id] <= 0:
		checkout_list.erase(id)
		for container in container_list:
			if container.id == id:
				container.queue_free()
				container_list.erase(container)
				return
			
func set_checkout_value(value):
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

func open_item_interface():
	if UI.is_ui_free():
			UI.is_free(false)
			visible = true
			
func _on_buy_button_down():
	if Gold.pay(checkout_gold_total()):
		spawn_bought_items.emit(checkout_list)
		clear_checkout()

func _on_return_button_down():
	clear_checkout()
	UI.is_free(true)
	visible = false
