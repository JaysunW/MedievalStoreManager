extends Node2D

var start_position = Vector2.ZERO
var item_pressed = false
var type = null


signal item_selected(type)
signal item_deselected

func _ready():
	start_position = $TextureButton.position

func _process(_delta):
	if item_pressed:
		$TextureButton.position = to_local(get_global_mouse_position())

func set_type(_type):
	type = _type
	
func set_sprite(_sprite):
	$TextureButton.texture_normal = _sprite
	
func set_locked():
	$TextureButton.modulate = Color(0,0,0)

func _on_texture_button_button_down():
	item_selected.emit(type)
	item_pressed = true


func _on_texture_button_button_up():
	item_deselected.emit()
	item_pressed = false
	$TextureButton.position = start_position
