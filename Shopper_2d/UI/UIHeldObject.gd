extends CanvasLayer
@export var item_icon : TextureRect
@export var item_current_amount : Label
@export var item_amount : Label
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
	item_icon.texture = load(data["sprite_path"])
	item_current_amount.text = str(data["amount"])
	item_amount.text = "/" + str(data["max_amount"])
