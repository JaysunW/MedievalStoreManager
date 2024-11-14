extends CanvasLayer
@export var item_icon : TextureRect
@export var item_current_amount : Label
@export var item_amount : Label

@onready var flash_held_object_ui_timer = $"../FlashHeldObjectUITimer"

var is_flashing_color = false

func _ready():
	visible = false
	item_icon.texture = null
	item_amount.text = ""
	
func dropped_object():
	item_icon.texture = null
	item_amount.text = ""
	visible = false
	
func set_held_object_data(data):
	visible = true
	item_icon.texture = Loader.texture(data["sprite_path"])
	item_current_amount.text = str(data["amount"])
	item_amount.text = "/" + str(data["carry_max"])

func flash_color(color, flash_time = 0.1):
	if not is_flashing_color:
		is_flashing_color = true
		item_current_amount.modulate = color
		item_amount.modulate = color
		flash_held_object_ui_timer.start(flash_time)

func _on_flash_held_object_ui_timer_timeout():
	is_flashing_color = false
	item_current_amount.modulate = Color.WHITE
	item_amount.modulate = Color.WHITE