extends ObjectOnTile

func update_sprite():
	match type:
		0:
			animation = "Basic" 
		1:
			animation = "Roll"
		2:
			animation = "Clean"
		3:
			animation = "Open"
		Enums.TileType.UNKNOWN:
			print("Something went wrong with the coral sprite update.")
		_:
			animation = "Basic"
			print("Not enough corals for the area count")
	sprite.animation = animation
	frame = rng.randi_range(0, sprite.sprite_frames.get_frame_count(animation)) # Could be done with noise to make it not random
	sprite.frame = frame

func destroyed():
	DropService.call("place_shell_drop_at", to_global(position), "Pearl", 0)
	super()
