extends Sprite2D

@export var sprites : Array[Texture2D]

func change_sprite(number):
	texture = sprites[number]
