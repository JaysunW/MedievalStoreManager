extends Area2D

@export var sprite_component : Sprite2D
var objects_inside_door = 0

func _on_body_entered(body: Node2D) -> void:
	objects_inside_door += 1
	if objects_inside_door > 0:
		sprite_component.change_sprite(1)


func _on_body_exited(body: Node2D) -> void:
	objects_inside_door -= 1
	if objects_inside_door <= 0:
		sprite_component.change_sprite(0)
