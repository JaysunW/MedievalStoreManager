extends StaticBody2D

@onready var work_timer = $WorkTimer
@onready var flash_timer = $FlashTimer
@onready var show_progress_timer = $ShowProgressTimer
@onready var checkout_marker = $CheckoutMarker

@export var work_progress_bar : TextureProgressBar

var shopper_queue = []
var current_shopping_list = []
var whole_shopping_amount = 0
var in_work_cooldown = false
var shopper_count = 0
var checkout_queue_max = 7

func _ready():
	work_progress_bar.visible = false
	pass

func is_full():
	return shopper_count >= checkout_queue_max

func get_queue_size():
	return len(shopper_queue)
	
func get_marker():
	return checkout_marker

func reserve_spot():
	shopper_count += 1

func add_shopper(shopper):
	shopper_queue.append(shopper)
	
func work_on_queue():
	if shopper_queue.is_empty() or in_work_cooldown:
		return
	if current_shopping_list.is_empty():
		current_shopping_list = shopper_queue[0].get_basket_list()
		set_progress_bar(current_shopping_list)
	
	Gold.add_gold(current_shopping_list[0]["value"])
	work_timer.start()
	in_work_cooldown = true
	current_shopping_list.remove_at(0)
	update_progress_bar(current_shopping_list)
	if current_shopping_list.is_empty():
		shopper_queue[0].bought_basket()
		shopper_queue.remove_at(0)
		shopper_count -= 1
	print(current_shopping_list)

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
