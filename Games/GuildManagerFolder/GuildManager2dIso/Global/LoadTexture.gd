extends Node

func texture(path):
	if FileAccess.file_exists(path):
		return load(path)
	else:
		return load("res://Asset/32x32white.png")
