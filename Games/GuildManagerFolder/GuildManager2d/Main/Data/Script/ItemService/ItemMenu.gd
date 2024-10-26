extends CanvasLayer

@onready var item_store_parent = $ItemStore/MarginContainer/VBoxContainer/ItemStoreParent
@onready var checkout_parent = $ItemCheckout/VBoxContainer/MarginContainer/ScrollContainer/CheckoutParent

@export var item_container : PackedScene
@export var item_checkout_container : PackedScene

signal chose_item_option(String)
signal spawn_bought_items(Dictionary)

var container_list = []

var checkout_list = {}

func _ready():
	fill_container()
	visible = false

func fill_container():
	var item_data = Data.item_data
	for i in range(len(item_data)):
			if item_data[i]["unlocked"]:
				var new_container = item_container.instantiate()
				item_store_parent.add_child(new_container)
				new_container.get_pressed_signal().connect(chosen_container)
				new_container.set_container_info(i, item_data[i])

func clear_checkout():
	checkout_list = {}
	for container in container_list:
		container.queue_free()
	container_list = []

func chosen_container(pressed_container):
	var id = pressed_container.id
	if id in checkout_list.keys():
		if Gold.has_enough_gold(checkout_gold_total(pressed_container.content_data)):
			print("enough")
			checkout_list[id] += 1
			for container in container_list:
				if container.id == id:
					container.add_amount(1)
	else:
		if Gold.has_enough_gold(checkout_gold_total(pressed_container.content_data)):
			print("enough")
			var new_checkout_container = item_checkout_container.instantiate()
			checkout_parent.add_child(new_checkout_container)
			container_list.append(new_checkout_container)
			checkout_list[id] = 1
			new_checkout_container.get_pressed_signal().connect(containter_amount_check)
			new_checkout_container.set_container_info(id,pressed_container.content_data)
		
func checkout_gold_total(container_data= null):
	var item_data = Data.item_data
	var checkout_value = 0
	for key in checkout_list.keys():
		checkout_value += item_data[key]["average_value"] * item_data[key]["amount"]* checkout_list[key]
	if container_data:
		checkout_value += container_data["average_value"] * container_data["amount"]
	return checkout_value
		
func containter_amount_check(pressed_container):
	var id = pressed_container.id
	checkout_list[id] -= 1
	checkout_gold_total()
	if checkout_list[id] <= 0:
		checkout_list.erase(id)
		for container in container_list:
			if container.id == id:
				container.queue_free()
				container_list.erase(container)
				return
			
func _on_buy_button_down():
	if Gold.pay(checkout_gold_total()):
		spawn_bought_items.emit(checkout_list)
		clear_checkout()

func _on_item_interface_open_item_ui():
	if UI.is_ui_free():
		UI.is_free(false)
		visible = true

func _on_return_button_down():
	clear_checkout()
	UI.is_free(true)
	visible = false
