extends Area2D

func get_interactable_object():
	return get_overlapping_areas()
