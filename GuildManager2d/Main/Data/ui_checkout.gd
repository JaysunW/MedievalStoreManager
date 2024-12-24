extends CanvasLayer

func _ready() -> void:
	#visible = false
	UI.change_checkout_UI.connect(set_checkout_info)
	
func set_checkout_info(is_visible : bool, info):
	
	visible = is_visible
	print(info)
