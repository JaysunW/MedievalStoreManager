extends Node2D

@onready var package_spawn_position = $PackageSpawnPosition

@export var world_map : Node2D
@export var package_scene : PackedScene
@export var spawn_offset_min_max = Vector2(-32, 32)

var checkout_list = []
	
func interact():
	UI.open_item_menu_UI.emit()
	SignalService.restrict_player()
	
func _on_ui_item_menu_spawn_bought_items(checkout_items):
	var item_data = Data.item_data
	var rng = RandomNumberGenerator.new()
	for id in checkout_items.keys():
		for amount in checkout_items[id]:
			var new_package = package_scene.instantiate()
			var content_data = item_data[id].duplicate()
			new_package.set_content(content_data)
			world_map.add_child(new_package)
			new_package.position = to_global(package_spawn_position.position) + Vector2(rng.randi_range(spawn_offset_min_max.x,spawn_offset_min_max.y), rng.randi_range(spawn_offset_min_max.x,spawn_offset_min_max.y))
