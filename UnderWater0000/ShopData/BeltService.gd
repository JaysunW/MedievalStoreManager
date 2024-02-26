extends Sprite2D

@onready var belt0 = $Clipping/Belt0
@onready var belt1 = $Clipping/Belt1
#@onready var belt3 = $Belt3
#@onready var belt4 = $Belt4

@export var belt_speed = 50
@export var showcase_scene : PackedScene

var belt_item_list = []
var belts = []
var move_list = [0,0,0,0]
var move_dir = 0

func _ready():
	belts = [belt0, belt1]
	for belt in belts:
		belt_item_list.append([])
	add_every_laser()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	belt0.position += Vector2.LEFT * move_dir * delta * belt_speed
	belt1.position += Vector2.LEFT * move_dir * delta * belt_speed
#	belt3.position += Vector2.LEFT * move_dir * delta * belt_speed
#	belt4.position += Vector2.LEFT * move_dir * delta * belt_speed

func add_every_laser():
	var tool_data = LoadoutService.get_tool_stats()
	for laser in tool_data["laser"]:
		print(laser)
		add_container(0, load(laser["sprite_path"]), laser["type"], false)
		add_container(1, load(laser["sprite_path"]), laser["type"])

func _on_green_button_down():
	move_dir = 1

func _on_green_button_up():
	move_dir = 0

func _on_red_button_down():
	move_dir = -1

func _on_red_button_up():
	move_dir = 0

# when adding new belts change the other!
func add_container(belt_nr, sprite, type, unlocked = true):
	print("Added: " + str(sprite))
	var new_container = showcase_scene.instantiate()
	belts[belt_nr].add_child(new_container)
	new_container.position = Vector2(32 * belt_item_list[belt_nr].size(),0)
	new_container.set_type(type)
	new_container.set_sprite(sprite)
	if not unlocked: new_container.set_locked()
	belt_item_list[belt_nr].append(new_container)
