extends Sprite2D

@export var sprites : Array[Texture2D]

func change_sprite(number):
	texture = sprites[number]

func rotate_sprite(next_frame):
	if next_frame < hframes:
		frame = next_frame

func offset_sprite(offset_vector):
	position = offset_vector
