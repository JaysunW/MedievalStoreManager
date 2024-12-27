extends CanvasLayer

@export var checkout_container : PackedScene
@export var customer_visual : PackedScene
@export var visual_parent : PanelContainer
@export var checkout_container_parent : VBoxContainer
@export var visual_position_list : Array[Marker2D]
@export var end_position : Marker2D

var scale_list = [Vector2.ONE * 12,Vector2.ONE * 8,Vector2.ONE * 6,Vector2.ONE * 5]
var color_list = [255/255, 220/255, 195/255,155/255, 120/255]

var customer_list = []
var customer_visual_list = []
var container_list = []

var total_payment = 0
var total_change = 0

func _ready() -> void:
	visible = false
	UI.open_checkout_UI.connect(show_UI)
	UI.add_customer_checkout_UI.connect(add_customer)
	UI.remove_customer_checkout_UI.connect(remove_customer)
	
func show_UI(input : bool):
	visible = input
	
func add_customer(customer):
	customer_list.append(customer)
	var customer_icon = customer_visual.instantiate()
	customer_icon.position = visual_position_list.back().position
	visual_parent.add_child(customer_icon)
	customer_visual_list.append(customer_icon)
	sort_customer_visual()
	if len(customer_list) == 1:
		show_customer_shopping_list(customer)
	# generate image
	
func sort_customer_visual():
	for i in range(len(customer_visual_list)):
		var current_visual = customer_visual_list[i]
		var new_position = visual_position_list.back().position
		var new_scale = scale_list.back()
		var new_color = color_list.back()
		if i < len(visual_position_list):
			new_position = visual_position_list[i].position
		if i < len(scale_list):
			new_scale = scale_list[i]
		if i < len(color_list):
			new_color = color_list[i]
		current_visual.set_target_position(new_position)
		current_visual.set_target_scale(new_scale)
		current_visual.set_target_color(Color(new_color, new_color, new_color))
		current_visual.z_index = 5 - i
	
func add_change(value: int):
	total_change += value
	print("Change: ",total_change)

func multiply_change(mulitplier: float):
	total_change = int(total_change * mulitplier)

func customer_paid():
	if not len(customer_list) > 0:
		return
	if total_change < total_payment:
		return
		
	if Gold.pay(total_change):
		Gold.add_gold(total_payment)
		SignalService.next_customer.emit()
		customer_list.pop_front()
		remove_customer_visual()
		if len(customer_list) > 0:
			sort_customer_visual()
			show_customer_shopping_list(customer_list.front())

func remove_customer_visual():
	var customer_icon = customer_visual_list.pop_front()
	customer_icon.last_position()
	customer_icon.set_target_position(end_position.position)
	customer_icon.z_index = 6
	
func show_customer_shopping_list(customer):
	total_change = 0
	total_payment = 0
	for container in container_list:
		container.queue_free()
	container_list.clear()
	var basket = customer.get_basket_list()
	for content_data in basket:
		total_payment += content_data["value"] * content_data["amount"]
		var container = checkout_container.instantiate()
		checkout_container_parent.add_child(container)
		container.set_container_info(content_data)
		container_list.append(container)
	print("To pay: ", total_payment)


func remove_customer():
	customer_list.pop_front()
