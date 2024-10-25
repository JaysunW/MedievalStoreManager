extends Node2D

var button = null
var start_position = Vector2.ZERO
var item_pressed = false
var data = null
var initial_color = Color(1,1,1)
var is_item_bought = false

signal item_selected(data, container)
signal item_deselected

func _ready():
	button = $TextureButton
	start_position = button.position

func _process(_delta):
	if item_pressed:
		pass
		# Idea to drop an item in the area to buy
		#button.position = to_local(get_global_mouse_position())

func item_bought():
	is_item_bought = true
	item_pressed = false
	button.position = start_position
	$PrizeTagBack.visible = false
	button.disabled = true
	button.modulate = Color(1,1,1)

func not_bought():
	$PrizeTagBack/PrizeTagBack2/Label.add_theme_color_override("font_color", Color(1, 0, 0))
	$PrizeTagBack/PrizeTagBack2/Label.add_theme_color_override("font_shadow_color", Color(1, 0, 0))
	$Cross.visible = true
	$NotBuyable.start()
	
func set_container(_data):
	set_data(_data)
	set_sprite(load(_data["sprite_path"]))
	set_price(_data["price"])
	is_unlocked(_data["unlocked"])
	
func set_data(_data):
	data = _data
	
func set_sprite(sprite):
	if sprite:
		button.texture_normal = sprite
	else:
		print("No sprite fround from shop : ShowcaseContainer")
	
func is_unlocked(input):
	if input:
		initial_color = Color(1,1,1)
		button.position = start_position
		$PrizeTagBack.visible = false
		button.disabled = true
	else:
		button.modulate = Color(0,0,0)
		initial_color = Color(0,0,0)
	
func set_price(prize):
	if int(prize) == 100000000:
		$PrizeTagBack/PrizeTagBack2/Label.text = "???"
	else:
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
	
func _on_not_buyable_timeout():
	$PrizeTagBack/PrizeTagBack2/Label.remove_theme_color_override("font_color")
	$PrizeTagBack/PrizeTagBack2/Label.remove_theme_color_override("font_shadow_color")
	$Cross.visible = false

func _on_texture_button_mouse_entered():
	if not is_item_bought:
		$TextureButton.position = $TextureButton.position - Vector2( 3, 3)
		$TextureButton.scale = Vector2( 1, 1)
		$PrizeTagBack.scale = Vector2( 0.8, 0.25)
	
func _on_texture_button_mouse_exited():
	$TextureButton.position = start_position
	$TextureButton.scale = Vector2( 0.8, 0.8)
	$PrizeTagBack.scale = Vector2( 0.75, 0.2)
