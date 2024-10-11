extends Sprite2D

@export var sprites : Array[Texture2D]

func change_to_sprite(number):
	texture = sprites[number]
