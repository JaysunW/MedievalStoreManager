extends Node2D
@export var customer : CharacterBody2D
@export var view_area_parent : Node2D
var view_area_list  : Array[Area2D]

func _ready() -> void:
	for child in view_area_parent.get_children():
		view_area_list.append(child)

func change_look_direction(dir):
	view_area_parent.look_at(dir)

func get_seen_areas():
	var seen_areas = []
	for view in view_area_list:
		var overlapp_area_list = view.get_overlapping_areas()
		for area in overlapp_area_list:
			if not area in seen_areas:
				seen_areas.append(area)
	return seen_areas
