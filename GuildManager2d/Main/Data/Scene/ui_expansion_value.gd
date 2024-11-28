extends CanvasLayer

@export var item_current_amount: Label

func set_value(value):
	item_current_amount.text = str(value)
