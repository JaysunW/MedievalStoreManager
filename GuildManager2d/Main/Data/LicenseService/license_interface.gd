extends StaticBody2D

func interact():
	if UI.get_set_ui_free():
		SignalService.restrict_player(true, true)
		UI.open_license_menu_UI.emit()
