extends Tool

@onready var sprite = $RotationPoint/Sprite

var strength = 0
var catch_change = 10
var catch_sizes = ["SMALL"]

func _ready():
	
	interactable_groups = ["FISH"]
	sprite.flip_v = true
	super()

func _process(_delta):
	super(_delta)

func update_tool(data):
	super(data)
	sprite.texture = load(data["sprite_path"])

# Use knife
func use_tool():
	#print("fish: ", objects_in_range)
	if active and not cooldown_active:
		super()
		sprite.flip_v = not sprite.flip_v
		for object in objects_in_range:
			object.try_catch_fish(catch_change * (strength + 1))

func entered_range(input):
	if not objects_in_range.has(input):
		for group in interactable_groups:
			if input.get_groups().has(group):
				objects_in_range.append(input)
				return
	
func exited_range(input):
	if input in objects_in_range:
		objects_in_range.erase(input)

func _on_area_2d_body_entered(body):
	entered_range(body)

func _on_area_2d_body_exited(body):
	exited_range(body)
