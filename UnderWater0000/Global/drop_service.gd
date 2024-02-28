extends Node2D

var drop_scene : PackedScene

var rng = RandomNumberGenerator.new()

var drop_list = {}
var drop_counter = 0
	
func _ready():
	drop_scene = preload("res://Data/Drops/drop.tscn")
	
func set_drop_signal(sig):
	sig.connect(_place_drop_at)
	
func _place_drop_at( pos, border_idx, texture):
	var drop = drop_scene.instantiate()
	add_child(drop)
	drop.position = pos
	drop.set_texture(texture)
	drop.set_border_idx(border_idx)
	drop_list[drop_counter] = drop
	if pos.y >= grid_service.water_edge_y:
		drop.gravity_scale = 0.1
	drop.linear_damp = 0.8
	drop.rotation = rng.randi_range(0,360)
	drop.linear_velocity = Vector2(rng.randi_range(-5,6),rng.randi_range(-5,6)) * 8

func erase_drop(drop):
	drop_list.erase(drop)
