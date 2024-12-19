extends CanvasLayer

@export var item_current_amount: Label

func _ready() -> void:
	visible = false
	UI.open_expansion_UI.connect(set_value)

func set_value(value, open = true):
	visible = open
	item_current_amount.text = str(value)
