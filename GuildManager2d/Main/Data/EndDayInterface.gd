extends StaticBody2D

func interact():
	if UI.is_ui_free():
		SignalService.end_day.emit()
