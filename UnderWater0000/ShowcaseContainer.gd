extends Node2D

var button = null
var start_position = Vector2.ZERO
var item_pressed = false
var data = null

signal item_selected(data, container)
signal item_deselected

func _ready():
	button = $TextureButton
	start_position = button.position

func _process(_delta):
	if item_pressed:
		button.position = to_local(get_global_mouse_position())

func item_bought():
	item_pressed = false
	button.position = start_position
	$PrizeTagBack.visible = false
	button.disabled = true
	button.modulate = Color(1,0,0)
	
func set_data(_data):
	data = _data
	
func set_sprite(sprite):
	if sprite:
		button.texture_normal = sprite
	else:
		print("No sprite fround from shop : ShowcaseContainer")
	
func set_locked():
	button.modulate = Color(0,0,0)
	
func set_prize(prize):
	$PrizeTagBack/PrizeTagBack2/Label.text = GoldService.convert_value_to_str(prize)

func get_select_signal():
	return item_selected

func get_deselect_signal():
	return item_deselected

func _on_texture_button_button_down():
	item_pressed = true
	item_selected.emit(data, self)

func _on_texture_button_button_up():
	item_deselected.emit()
	item_pressed = false
	button.position = start_position
