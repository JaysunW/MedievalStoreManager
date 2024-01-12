extends Node2D

@onready var o2_bar = $Node2D/TextureRect

var start_pos = Vector2.ZERO
var loss = 50

func _ready():
	start_pos = o2_bar.position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("o"):
		loss += 10
		print(loss)
	if Input.is_action_just_pressed("p"):
		loss -= 10
		print(loss)
	if Input.is_action_just_pressed("i"):
		update_o2(100.0,100.0 - loss)
		
func update_o2(max_cap, lost_o2):
	var current_cap = lost_o2/max_cap
	o2_bar.set_size(Vector2(o2_bar.get_size().x, current_cap * 32))
	o2_bar.position = Vector2(start_pos.x,start_pos.y + (1-current_cap) * 32)
	print("S: " + str(o2_bar.get_size()))
	print(current_cap * 32)
	print("P: " + str(o2_bar.position) )
	print((1-current_cap) * 32)
