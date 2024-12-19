extends StaticBody2D

func interact():
	if UI.get_set_ui_free():
		UI.open_license_menu_UI.emit()
