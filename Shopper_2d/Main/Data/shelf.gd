extends StaticBody2D

@export var package_scene : PackedScene

@onready var skin = $SpriteComponent
@onready var collision = $Collision

var tile_map_reference = null
var content_type = Utils.ContentType.EMPTY


# Called when the node enters the scene tree for the first time.
func _ready():
	skin.modulate = Color(1,1,1,0.8)
	collision.set_deferred("disabled", true)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func prepare_stand():
	collision.set_deferred("disabled", false)
	skin.modulate = Color(1,1,1,1)

func change_color(color):
	skin.modulate = color

func rotate_object():
	rotation_degrees = (int(rotation_degrees) + 90) % 360
	
func set_content(content):
	if content_type != Utils.ContentType.EMPTY:
		print_debug("Error set filled shelf with new content")
	content_type = content.content_type
	skin.change_sprite(1)
	content.queue_free()

func take_content():
	var content = get_content()
	empty_content()
	return content
	
func get_content():
	var content = package_scene.instantiate()
	content.content_type = content_type
	tile_map_reference.add_child(content)
	return content

func empty_content():
	if content_type == Utils.ContentType.EMPTY:
		print_debug("Error empied empty shelf")
	content_type = Utils.ContentType.EMPTY
	skin.change_sprite(0)

func is_empty():
	return content_type == Utils.ContentType.EMPTY
