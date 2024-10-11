extends StaticBody2D

var content = null
@onready var skin = $SpriteComponent
@onready var collision = $Collision

# Called when the node enters the scene tree for the first time.
func _ready():
	print("fst. ", rotation)
	skin.modulate = Color(1,1,1,0.8)
	collision.set_deferred("disabled", true)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func prepare_stand():
	collision.set_deferred("disabled", false)
	skin.modulate = Color(1,1,1,1)

func change_color(color):
	skin.modulate = color

func rotate_object():
	rotation_degrees = (int(rotation_degrees) + 90) % 360
	
func set_content(input):
	content = input
	
func empty_content():
	content = null
