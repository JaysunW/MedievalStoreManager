extends StaticBody2D

@onready var work_timer = $WorkTimer
@onready var flash_timer = $FlashTimer

var next_shopper_queue = []

var current_item_list = [[10],[9],[20],[15],[5],[13]]
var in_work_cooldown = false

func add_shopper(shopper):
	next_shopper_queue.append(shopper)
	
func work_on_queue():
	if not in_work_cooldown and not next_shopper_queue.is_empty():
		work_timer.start()
		in_work_cooldown = true
		current_item_list[0] -= 1
		print(current_item_list[0])

func _on_work_timer_timeout():
	in_work_cooldown = false
	pass # Replace with function body.
