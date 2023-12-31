extends Drop

func update_sprite():
	$Sprite.animation = "A" + str(type)
