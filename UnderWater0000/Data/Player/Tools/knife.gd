extends Tool

@onready var sprite = $RotationPoint/Sprite
@onready var area_to_attack = $Area2D

func _ready():
	sprite.flip_v = true
	super()

func _process(_delta):
	super(_delta)

func disable(input):
	$Area2D.monitoring = input

# Use knife
func use_tool():
	if not cooldown_active:
		super()
		sprite.flip_v = not sprite.flip_v
		for object in objects_in_range:
			object.call("take_damage", damage)

func _on_area_2d_area_entered(area):
	for group in interactable_groups:
		if area.get_groups().has(group) and area.get_parent() not in objects_in_range:
			objects_in_range.append(area.get_parent())
			break

func _on_area_2d_area_exited(area):
	if area.get_parent() in objects_in_range:
		objects_in_range.erase(area.get_parent())
