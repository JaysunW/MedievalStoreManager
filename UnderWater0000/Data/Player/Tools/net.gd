extends Tool

@onready var sprite = $RotationPoint/Sprite

var strength = 2

func _ready():
	sprite.flip_v = true
	super()

func _process(_delta):
	super(_delta)

# Use knife
func use_tool():
	if active and not cooldown_active:
		super()
		sprite.flip_v = not sprite.flip_v

func entered_range(input):
	for group in interactable_groups:
		if input.get_groups().has(group) and input not in objects_in_range:
			objects_in_range.append(input)
			print(objects_in_range)
			break
	
func exited_range(input):
	if input in objects_in_range:
		objects_in_range.erase(input)

func _on_area_2d_body_entered(body):
	entered_range(body)

func _on_area_2d_body_exited(body):
	exited_range(body)
