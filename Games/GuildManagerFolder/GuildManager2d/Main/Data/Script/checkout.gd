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
var checkout_queue_max = 7

func _ready():
	pass

func is_full():
	return len(shopper_queue) >= 7

func get_marker():
	return checkout_marker

func get_queue_size():
	return len(shopper_queue)

func add_shopper(shopper):
	shopper_queue.append(shopper)
	
func work_on_queue():
	if shopper_queue.is_empty():
		return
	current_shopping_list = shopper_queue[0].get_basket_items()
	if current_shopping_list.is_empty() or in_work_cooldown:
		return
		#Take shopped_items from shopper:
			#TODO: 
	work_timer.start()
	in_work_cooldown = true
	current_shopping_list[0] -= 1
	update_progress_bar()
	if current_shopping_list[0] == 0:
		current_shopping_list.remove_at(0)
	print(current_shopping_list)

func set_progress_bar(shopping_list):
	var shopping_size = 0
	for item in shopping_list:
		shopping_size += item
	work_progress_bar.min_value = 0
	work_progress_bar.max_value = shopping_size
	work_progress_bar.value = shopping_size
	work_progress_bar.visible = true
	show_progress_timer.start()

func update_progress_bar():
	work_progress_bar.value -= 1
	work_progress_bar.visible = true
	show_progress_timer.start()
	
func _on_work_timer_timeout():
	in_work_cooldown = false

func _on_show_progress_timer_timeout():
	work_progress_bar.visible = false
