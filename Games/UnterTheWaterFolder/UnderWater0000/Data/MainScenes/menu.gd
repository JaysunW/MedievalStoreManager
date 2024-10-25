extends Node2D

func _on_start_button_down():
	SceneSwitcherService.switch_scene("res://Data/MainScenes/main.tscn")

func _on_load_button_down():
	DataService.load_save()
	SceneSwitcherService.switch_scene("res://Data/MainScenes/main.tscn")
