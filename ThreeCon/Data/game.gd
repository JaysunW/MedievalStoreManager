extends Node2D

@export var container : PackedScene
@export var width = 20
@export var height = 20

var container_dic = {}

var gem_list = ["blue", "green", "orange", "purple", "red"]
var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	position_camera()
	create_map()
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
	
func position_camera():
	$Camera2D.position = Vector2(width/2.0,height/2.0) * 31

func create_map():
	for y in range(height):
		for x in range(width):
			var new_container = container.instantiate()
			add_child(new_container)
			new_container.position = Vector2(x, y) * 32
			var sprite_name = gem_list[rng.randi_range(0,gem_list.size()-1)]
			new_container.setup_display(load("res://Assets/Gem/gem_" + sprite_name + ".png"))
			new_container.set_type(sprite_name)
			container_dic[Vector2(x,y)] = new_container

func get_size():
	return Vector2(width,height)
