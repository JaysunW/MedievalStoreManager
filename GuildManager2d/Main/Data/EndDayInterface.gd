extends StaticBody2D

func interact():
	if UI.is_ui_free():
		SignalService.try_ending_day.emit()
