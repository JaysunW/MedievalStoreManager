extends Node2D

@onready var sprite = $RotationPoint/Sprite
@onready var area_to_attack = $Area2D

var flip_counter = 1
var rotation_degree_list = [0,90]

var damage = 20
var cooldown = 1
var cooldown_active = false
var attackable_groups = ["FISH","CORAL"]

var objects_in_range = []

func _ready():
	$Cooldown.wait_time = cooldown
	sprite.flip_v = true

func _process(_delta):
	var mouse_pos = get_global_mouse_position()
	look_at(mouse_pos)
	if Input.is_action_pressed("left_mouse_button"):
		use_knife()

# Use knife
func use_knife():
	if not cooldown_active:
		sprite.flip_v = not sprite.flip_v
		cooldown_active = true
		$Cooldown.start()
		$RotationPoint.rotation = rotation_degree_list[flip_counter]
		flip_counter = (flip_counter + 1) % 2
		for object in objects_in_range:
			object.call("take_damage", damage)

# Cooldown timer
func _on_cooldown_timeout():
	cooldown_active = false

func _on_area_2d_area_entered(area):
	for group in attackable_groups:
		if area.get_groups().has(group) and area.get_parent() not in objects_in_range:
			objects_in_range.append(area.get_parent())
			print(objects_in_range)
			break

func _on_area_2d_area_exited(area):
	if area.get_parent() in objects_in_range:
		objects_in_range.erase(area.get_parent())
