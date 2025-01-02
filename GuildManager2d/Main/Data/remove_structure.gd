extends Node2D

@export var build_service : Node2D
@export var store_area : TileMapLayer

func Enter():
	pass

func Exit():
	build_service.child_exit()


func Process(_delta: float) -> void:
	if Input.is_action_pressed("right_mouse"):
		Exit()
		return
	var mouse_pos = get_global_mouse_position()
	var mouse_tile_pos : Vector2i = store_area.local_to_map(mouse_pos)
	
