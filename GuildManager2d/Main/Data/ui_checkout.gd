extends CanvasLayer

@export var checkout_container : PackedScene
@export var checkout_container_parent : VBoxContainer

var customer_list = []
var customer_visual_list = []
var customer_image_list = []
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
	var new_customer_sprite = Sprite2D.new()
	
	customer_visual_list.append()
	if len(customer_list) == 1:
		show_customer_shopping_list(customer)
	# generate image
	pass
	
func sort_customer_visual():
	
	
func add_change(value: int):
	total_change += value
	print("Change: ",total_change)

func multiply_change(mulitplier: float):
	total_change = int(total_change * mulitplier)

func customer_paid():
	if total_change >= total_payment:
		if Gold.pay(total_change):
			Gold.add_gold(total_payment)
			SignalService.next_customer.emit()
			customer_list.pop_front()
			if len(customer_list) > 0:
				show_customer_shopping_list(customer_list.front())

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
