extends StaticBody2D

@onready var work_timer = $WorkTimer
@onready var flash_timer = $FlashTimer
@onready var show_progress_timer = $ShowProgressTimer

@export var work_progress_bar : TextureProgressBar


var next_shopper_queue = []

var current_shopping_list = [1,2,3,4,5,6,7,8]
var whole_shopping_amount = 0
var in_work_cooldown = false

func _ready():
	set_progress_bar(current_shopping_list)

func add_shopper(shopper):
	next_shopper_queue.append(shopper)
	
func work_on_queue():
	if current_shopping_list.is_empty():
		work_progress_bar.visible = false
		print("Next Shopper")
		#Take next shopper:
		#TODO: 
		pass
	else:
		if not in_work_cooldown:
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
