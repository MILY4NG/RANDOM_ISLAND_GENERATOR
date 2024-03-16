extends Node2D

const WIDTH: int = 512	
const HEIGHT: int = 512

onready var tilemap = $TileMap
onready var ysort = $YSort

var rng: RandomNumberGenerator = RandomNumberGenerator.new()
var noise: OpenSimplexNoise = OpenSimplexNoise.new()
var map_seed: float = 2312412
var map_scale: float = 55
var tile_height: Array = [0.23, 0.85, 0.95, 1.0]
var tree = preload("res://Scenes/Tree.tscn")
var weed = preload("res://Scenes/Weed.tscn")

func _ready() -> void:
	generate_map()
	
#func _unhandled_input(event):
#	if event is InputEventKey and event.is_pressed() and not event.is_echo():
#		var k = OS.get_scancode_string(event.scancode)
#
#		if k == "Space":
#			generate_map()
			

func get_tile_id(height: float) -> int:
	for i in range(len(tile_height)):
		if height < tile_height[i]:
			return i
			
	return 3

func generate_map() -> void:
	rng.randomize()
	map_seed = rng.randf_range(1000.0, 2321242.0)
	noise.seed = rng.randf()
	noise.period = 0.78
	noise.octaves = 6
	
	for y in range(HEIGHT):
		for x in range(WIDTH):
			var distanceX = (WIDTH/2 - x) * (WIDTH/2 - x)
			var distanceY = (HEIGHT/2 - y) * (HEIGHT/2 - y)
			
			var distanceToCenter = sqrt(distanceX + distanceY) * 0.0062
			
			tilemap.set_cellv(Vector2(x, y), get_tile_id(noise.get_noise_2d((float(x) + map_seed) / map_scale, (float(y) + map_seed) / map_scale) + distanceToCenter))
			if tilemap.get_cellv(Vector2(x, y)) == 1:
				rng.randomize()
				var t: int = rng.randi_range(0, 20)
				if t < 5:
					var instance_tree = tree.instance()
					instance_tree.init(Vector2(x*16+8, y*16))
					ysort.add_child(instance_tree)
				else:
					rng.randomize()
					var w: int = rng.randi_range(0, 20)
					if w == 0:
						var instance_weed = weed.instance()
						instance_weed.position = Vector2(x*16+8, y*16+8)
						ysort.add_child(instance_weed)
