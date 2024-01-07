extends Tool

@onready var sprite = $RotationPoint/Sprite
@onready var area_to_attack = $Area2D

func _ready():
	interactable_groups = ["FISH","CORAL","SHELL"]
	sprite.flip_v = true
	super()

func _process(_delta):
	super(_delta)

# Use knife
func use_tool():
	if active and not cooldown_active:
		super()
		sprite.flip_v = not sprite.flip_v
		for object in objects_in_range:
			object.call("take_damage", damage)

func entered_range(input):
	for group in interactable_groups:
		if input.get_groups().has(group) and input not in objects_in_range:
			objects_in_range.append(input)
			print(objects_in_range)
			break
	
func exited_range(input):
	if input in objects_in_range:
		objects_in_range.erase(input)

func _on_area_2d_area_entered(area):
	entered_range(area.get_parent())

func _on_area_2d_area_exited(area):
	exited_range((area.get_parent()))

func _on_area_2d_body_entered(body):
	entered_range(body)


func _on_area_2d_body_exited(body):
	exited_range(body)
