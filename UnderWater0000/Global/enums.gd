extends Node2D

# Visual ordering 
# 1- 10:
#11- 20: Foliage
#21- 30: Background
#31- 40:
#41- 50: Character
#51- 60:
#61- 70: Foreground
#71- 80:
#81- 90:

enum Dir {
	North,
	East,
	South,
	West
}

enum TileType {
	A0,
	A1,
	A2,
	A3,
	A4,
	A5,
	A6,
	UNKNOWN
}

enum CoralType {
	A0,
	A1,
	A2,
	A3,
	A4,
	A5,
	A6,
	UNKNOWN
}

enum SeaWheatType {
	A0,
	A1,
	A2,
	A3,
	A4,
	A5,
	A6,
	UNKNOWN
}

enum ShellfishType {
	A0,
	A1,
	A2,
	A3,
	A4,
	A5,
	A6,
	UNKNOWN
}

enum DropType {
	TILE,
	CORAL,
	SHELL,
	UNKNOWN
}

enum FishState{
	SWIMMING,
	CHASING,
	IDLE
}

enum Scene{
	Game,
	Shop,
	Library,
	Aquarium,
	Unknown
}

enum ShopItem{
	LASER,
	NET,
	KNIFE,
	O2TANK,
	BELL
}

enum Laser{
	SECOND,
	THIRD,
	FORTH,
	FISH
}

enum Net{
	SECOND,
	THIRD,
	FORTH,
	FISH
}

enum Knife{
	SECOND,
	THIRD,
	FORTH,
	FISH
}
