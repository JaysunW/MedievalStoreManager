extends Node2D

@export var drop_scene : PackedScene

var rng = RandomNumberGenerator.new()

var drop_list = {}
var drop_counter = 0

func place_tile_drop_at(pos, tileType, under_water):
	var drop = drop_scene.instantiate()
	drop.position = pos * 32
	drop.call("set_drop_service", self)
	drop.call("set_drop_type", tileType)
	drop.call("update_sprite")
	drop_list[drop_counter] = drop
	if under_water:
		drop.gravity_scale = 0.1
		drop.linear_damp = 0.8
	add_child(drop)
	drop.rotation = rng.randi_range(0,360)
	drop.linear_velocity = Vector2(rng.randi_range(-5,6),rng.randi_range(-5,6)) * 8

func place_coral_drop_at(pos, tileType):
	var drop = drop_scene.instantiate()
	drop.position = pos * 32
	drop.call("set_drop_service", self)
	drop.call("set_drop_type", tileType)
	drop.call("update_sprite")
	drop_list[drop_counter] = drop
	if under_water:
		drop.gravity_scale = 0.1
		drop.linear_damp = 0.8
	add_child(drop)
	drop.rotation = rng.randi_range(0,360)
	drop.linear_velocity = Vector2(rng.randi_range(-5,6),rng.randi_range(-5,6)) * 8

func erase_drop(drop):
	drop_list.erase(drop)

func _on_grid_service_drop_at_pos(pos, tile_type, input):
	place_drop_at(pos, tile_type, input)

func _on_water_area_body_entered(body):
	if body.get_groups().has("Drop"):
		body.linear_velocity = body.linear_velocity * 0.1
		body.gravity_scale = 0.1
		body.linear_damp = 0.8
