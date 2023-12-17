extends Node2D

@export var drop_scene : PackedScene

var drop_list = {}
var drop_counter = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func place_drop_at(pos, tileType):
	var drop = drop_scene.instantiate()
	drop.position = pos * 32
	drop.call("set_id", drop_counter)
	drop.call("set_drop_type", tileType)
	drop.call("update_sprite")
	drop_list[drop_counter] = drop
	add_child(drop)

# Delete child from list
func _on_child_exiting_tree(node):
	if node.get_groups().has("Drop"):
		drop_list.erase(node.get_id())

func _on_grid_service_drop_at_pos(pos, tile_type):
	place_drop_at(pos, tile_type)


func _on_water_area_body_entered(body):
	print("Dropped in Water")
	if body.get_groups().has("Drop"):
		print("Dropped in Water")
		body.linear_velocity = body.linear_velocity * 0.2
		body.gravity_scale = 0.2
		body.linear_damp = 0.7
