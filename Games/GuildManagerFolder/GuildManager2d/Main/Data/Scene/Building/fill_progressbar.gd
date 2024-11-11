extends TextureProgressBar

@onready var show_progress_timer: Timer = $ShowProgressTimer

func update_fill_progress(input_content_data):
	show_progress_timer.start()
	min_value = 0
	max_value = input_content_data["max_amount"]
	value = input_content_data["amount"]
	visible = true

func _on_show_progress_timer_timeout():
	visible = false
