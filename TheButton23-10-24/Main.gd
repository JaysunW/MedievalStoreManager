extends Node

var screen_size = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport().size
	$Button.position = Vector2(screen_size.x/2,screen_size.y/2)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
