extends CanvasLayer

@onready var item_store_parent = $ItemStore/MarginContainer/VBoxContainer/ItemStoreParent
@onready var checkout_parent = $ItemCheckout/VBoxContainer/MarginContainer/ScrollContainer/CheckoutParent

@export var copper_value_label: Label
@export var silver_value_label: Label
@export var gold_value_label: Label
@export var copper_icon: TextureRect
@export var silver_icon: TextureRect
@export var gold_icon: TextureRect

@export var item_container : PackedScene
@export var item_checkout_container : PackedScene

signal spawn_bought_items(Dictionary)

var container_list = []
var checkout_container_list = []

var checkout_list = {}

func _ready():
	visible = false
	UI.open_item_menu_UI.connect(open_item_interface)
	SignalService.new_license_bought.connect(new_license_unlocked)
	fill_container_with_unlocks()

func new_license_unlocked():
	for container in container_list:
		container.queue_free()
	container_list.clear()
	fill_container_with_unlocks()

func fill_container_with_unlocks():
	var item_data = Data.item_data
	for i in range(len(item_data)):
		i = item_data.keys()[i]
		if Global.is_license_unlocked([item_data[i]["store_area"]]):
			var new_container = item_container.instantiate()
			item_store_parent.add_child(new_container)
			new_container.get_pressed_signal().connect(chosen_container)
			new_container.set_container_info(i, item_data[i])
			container_list.append(new_container)

func clear_checkout():
	set_checkout_value(0)
	checkout_list = {}
	for container in checkout_container_list:
		container.queue_free()
	checkout_container_list.clear()

func chosen_container(pressed_container):
	var id = pressed_container.id
	var checkout_prize = checkout_gold_total(pressed_container.container_data)
	if Gold.has_enough_gold(checkout_prize):
		if id in checkout_list.keys():
			checkout_list[id] += 1
			for container in checkout_container_list:
				if container.id == id:
					container.add_amount(1)
		else:
			var new_checkout_container = item_checkout_container.instantiate()
			checkout_parent.add_child(new_checkout_container)
			checkout_container_list.append(new_checkout_container)
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
		for container in checkout_container_list:
			if container.id == id:
				container.queue_free()
				checkout_container_list.erase(container)
				return
			
func set_checkout_value(value):
	var label_list = [copper_value_label, silver_value_label, gold_value_label]
	var icon_list = [copper_icon, silver_icon, gold_icon]
	Global.set_value_display(value, label_list, icon_list)

func open_item_interface():
	if UI.get_set_ui_free():
		visible = true
			
func _on_buy_button_down():
	if Gold.pay(checkout_gold_total()):
		spawn_bought_items.emit(checkout_list)
		clear_checkout()

func _on_return_button_down():
	clear_checkout()
	UI.is_free(true)
	visible = false
	SignalService.restrict_player(false, false)
