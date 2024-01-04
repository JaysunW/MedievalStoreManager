extends Drop

var animation = null
var frame = null

func set_animation(input):
	animation = input

func set_frame(input):
	frame = input

func update_sprite():
	$Sprite.animation = animation
	$Sprite.frame = frame
