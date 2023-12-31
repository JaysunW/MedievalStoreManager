extends Drop

func update_sprite():
	$Sprite.animation = "A" + str(type)

func update_to_gem():
	pass
