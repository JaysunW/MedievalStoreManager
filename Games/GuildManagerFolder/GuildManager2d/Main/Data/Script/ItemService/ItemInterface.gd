extends Node2D

@onready var spawn_position = $SpawnPosition

@export var ui_item_menu : CanvasLayer
@export var tile_map : TileMap
@export var package : PackedScene

signal open_item_ui

var checkout_list = []
	
func open_item_store():
	print("Emit open Shop")
	open_item_ui.emit()
	
func _on_ui_item_menu_spawn_bought_items(checkout_items):
	print("Items to spawn: ", checkout_items)
	pass # Replace with function body.
