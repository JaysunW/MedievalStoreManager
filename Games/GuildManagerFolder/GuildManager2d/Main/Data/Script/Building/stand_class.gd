extends StaticBody2D
class_name StandClass

@onready var skin = $SpriteComponent
@onready var collision = $Collision
@onready var interaction_object_component = $InteractionObjectComponent
@onready var fill_progressbar = $FillProgressbar
@onready var show_content_icon = $ShowContentIcon
@onready var change_color_timer = $ChangeColorTimer

@export var package_scene : PackedScene
@export var content_data = {}
@export var tile_layer_ref : Node2D
@export var data = {}
@export var npc_marker : Marker2D

@export var tile_size = Vector2i(1, 1)
var orientation = Utils.Orientation.SOUTH

var is_flashing_color = false

# Called when the node enters the scene tree for the first time.
func _ready():
	
	fill_progressbar.visible = false
	show_content_icon.visible = false
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
	
func get_content_data():
	content_data["value"] = Data.item_data[content_data["id"]]["value"]
	return content_data
	
func get_npc_interaction_position():
	return npc_marker.global_position

func prepare_stand(should_prepare=true):
	if should_prepare:
		skin.modulate = Color(1,1,1,1)
	else:
		skin.modulate = Color(1,1,1,0.6)
	collision.set_deferred("disabled", not should_prepare)
	interaction_object_component.set_deferred("monitorable", should_prepare)
	
func change_color(color, change_alpha = false):
	if not is_flashing_color:
		if change_alpha:
			skin.modulate = color
		else:
			skin.modulate = Color(color.r,color.g,color.b, skin.modulate.a)

func rotate_object():
	rotation_degrees = (int(rotation_degrees) + 90) % 360

func get_content_amount():
	if content_data.is_empty():
		return 0
	return content_data["amount"]

func fill_shelf(content):
	var input_data = content.data.duplicate()
	if content_data.is_empty():
		content_data = input_data
		content_data["amount"] = 1
		skin.change_sprite(1)
		show_content_icon.texture = Loader.texture(content_data["sprite_path"])
		show_content_icon.visible = true
		fill_progressbar.update_fill_progress(content_data)
		Stock.add_to_stock(content_data["id"], self)
		return true
	elif content_data["id"] != input_data["id"]:
		flash_color(Color.FIREBRICK)
		return false
	content_data["amount"] += 1
	if content_data["amount"] > content_data["max_amount"]:
		content_data["amount"] = content_data["max_amount"]
		flash_color(Color.FIREBRICK)
		return false
	else:
		fill_progressbar.update_fill_progress(content_data)
		skin.change_sprite(1)
		Stock.add_to_stock(content_data["id"], self)
		return true

func take_from_shelf():
	content_data["amount"] -= 1
	if content_data["amount"] <= 0:
		fill_progressbar.visible = false
		show_content_icon.visible = true
		show_content_icon.texture = null
		Stock.take_from_stock(content_data["id"], self, true)
		empty_content()
	else:
		#Depending on fill scale:
		skin.change_sprite(1)
		fill_progressbar.update_fill_progress(content_data)
		Stock.take_from_stock(content_data["id"], self)
	
func get_content_instance():
	var content = package_scene.instantiate()
	content.data = get_content_data().duplicate()
	content.position = global_position
	tile_layer_ref.add_child(content)
	return content

func empty_content():
	if content_data.is_empty():
		print_debug("Error empied empty shelf")
	content_data = {}
	skin.change_sprite(0)

func flash_color(color, flash_time = 0.1, change_alpha = false):
	if not is_flashing_color:
		is_flashing_color = true
		if change_alpha:
			skin.modulate = color
		else:
			skin.modulate = Color(color.r,color.g,color.b, skin.modulate.a)
		change_color_timer.start(flash_time)

func is_empty():
	return content_data.is_empty()

func _on_change_color_timer_timeout():
	is_flashing_color = false
	skin.modulate = Color(1,1,1)
