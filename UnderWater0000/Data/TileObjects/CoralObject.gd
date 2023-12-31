extends ObjectOnTile

func update_sprite():
	match type:
		Enums.TileType.A0:
			sprite.animation = "Basic"
		Enums.TileType.A1:
			sprite.animation = "Bowl"
		Enums.TileType.A2:
			sprite.animation = "Brain"
		Enums.TileType.A2:
			sprite.animation = "Rock"
		Enums.TileType.A3:
			sprite.animation = "Tree"
		Enums.TileType.A4:
			sprite.animation = "Brain"
		Enums.TileType.A5:
			sprite.animation = "Brain"
		Enums.TileType.UNKNOWN:
			print("Something went wrong with the coral sprite update.")
	sprite.frame = rng.randi_range(0, sprite.get_frame_count())
