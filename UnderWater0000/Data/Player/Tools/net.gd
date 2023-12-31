extends Tool

@onready var sprite = $RotationPoint/Sprite

var strength = 2

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
