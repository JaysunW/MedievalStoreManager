extends StaticBody2D

@onready var work_timer = $WorkTimer
@onready var flash_timer = $FlashTimer
@onready var show_progress_timer = $ShowProgressTimer
@onready var checkout_marker = $CheckoutMarker

@export var work_progress_bar : TextureProgressBar

var opened_menu = false

var is_working : bool = false

var customer_queue : Array = []
var current_shopping_list : Array = []
var whole_shopping_amount : int = 0

var in_work_cooldown : bool = false

var checkout_queue_max : int= 7
var reserved_spots = 0

signal new_customer
signal next_customer
signal no_customer

func _ready():
	SignalService.next_customer.connect(remove_customer)
	work_progress_bar.visible = false
	pass

func is_full():
	return reserved_spots >= checkout_queue_max

func get_queue_size():
	return len(customer_queue)
	
func get_marker():
	return checkout_marker

func add_customer(customer):
	customer_queue.append(customer)
	new_customer.emit(customer)
	UI.add_customer_checkout_UI.emit(customer)
	return len(customer_queue) - 1

func reserve_spot():
	reserved_spots += 1
	if customer_queue.is_empty():
		return 
	new_customer.emit(customer_queue.back())

func interact():
	if UI.get_set_ui_free():
		change_work_mode()
		opened_menu = true
	elif opened_menu:
		change_work_mode()
		opened_menu = false
		UI.is_free(true)
	
func change_work_mode():
	if is_working:
		SignalService.restrict_player_movement.emit(false)
		SignalService.camera_offset.emit(Vector2.ZERO)
		UI.open_checkout_UI.emit(false)
		is_working = false
	else:
		SignalService.restrict_player_movement.emit(true)
		SignalService.camera_offset.emit(Vector2(-32*8,-32))
		UI.open_checkout_UI.emit(true)
		is_working = true
		##debug
		#customer_queue[0]
		

func remove_customer():
	var removed_customer = customer_queue.pop_front()
	if removed_customer:
		reserved_spots -= 1
		removed_customer.bought_basket()
		next_customer.emit()
	elif reserved_spots != 0:
		no_customer.emit()
#
#func work_on_queue():
	#if customer_queue.is_empty() or in_work_cooldown:
		#return
	#if not customer_queue.front().is_waiting_in_queue:
		#return 
		#
	#if current_shopping_list.is_empty():
		#current_shopping_list = customer_queue[0].get_basket_list()
		#set_progress_bar(current_shopping_list)
	#
	#Gold.add_gold(current_shopping_list[0]["value"])
	#work_timer.start()
	#in_work_cooldown = true
	#current_shopping_list.pop_front()
	#update_progress_bar(current_shopping_list)
	#if current_shopping_list.is_empty():
		#reserved_spots -= 1
		#customer_queue[0].bought_basket()
		#customer_queue.pop_front()
		#next_customer.emit()

func set_progress_bar(shopping_list):
	var shopping_size = len(shopping_list)
	work_progress_bar.min_value = 0
	work_progress_bar.max_value = shopping_size
	work_progress_bar.value = shopping_size
	work_progress_bar.visible = true
	show_progress_timer.start()

func update_progress_bar(list):
	work_progress_bar.value = len(list)
	work_progress_bar.visible = true
	show_progress_timer.start()
	
func _on_work_timer_timeout():
	in_work_cooldown = false

func _on_show_progress_timer_timeout():
	work_progress_bar.visible = false
