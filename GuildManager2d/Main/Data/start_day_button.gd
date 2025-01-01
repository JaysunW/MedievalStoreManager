extends Button

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalService.starting_work_day.connect(disable_button)
	SignalService.end_day.connect(show_button)
	pass # Replace with function body.

func show_button():
	visible = true
	
func disable_button():
	visible = false

func _on_button_down() -> void:
	SignalService.try_starting_work_day.emit()
	pass # Replace with function body.
