extends ObjectOnTile

func update_sprite():
	match type:
		0:
			animation = "Basic"
		1:
			animation = "Bowl"
		2:
			animation = "Brain"
		3:
			animation = "Rock"
		4:
			animation = "Tree"
		5:
			animation = "Brain"
		6:
			animation = "Brain"
		Enums.TileType.UNKNOWN:
			print("Something went wrong with the coral sprite update.")
	sprite.animation = animation
	frame = rng.randi_range(0, sprite.sprite_frames.get_frame_count(animation))
	sprite.frame = frame

func destroyed():
	DropService.call("place_coral_drop_at", to_global(position), animation, frame)
	super()
