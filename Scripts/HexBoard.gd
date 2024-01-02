extends Node3D

class_name HexBoard

@export var hexScene : PackedScene

const ORIGINAL_MATERIAL = preload("res://Materials/BasicHexMaterial.tres")
const TEST_MATERIAL = preload("res://Materials/test_boy_material.tres")
const TEST_MATERIAL_2 = preload("res://Materials/test_boy_material2.tres")
const TEST_MATERIAL_3 = preload("res://Materials/test_boy_material3.tres")
const TEST_MATERIAL_4 = preload("res://Materials/test_boy_material4.tres")


const TILE_SIZE = 1;
const TILE_START_ROT = 30;
const TILE_WIDTH = sqrt(3) * TILE_SIZE;
const TILE_HEIGHT = 2 * TILE_SIZE;
const TILE_OFFSET = 0.5 * TILE_WIDTH;
const GRID_SIZE = 10;

# Called when the node enters the scene tree for the first time.
func _ready():
	# test_walking_range(0, 0, 0, 7, true)
	_generate_grid(GRID_SIZE);

# Generates a square grid of size "size", sets Q, R, S coordinates for every tile
func _generate_grid(size) -> void:
	var startingQ = 0;
	var startingR = 0;
	var startingS = 0;
	
	for x in range(size):
		var curQ = x;
		var curR = startingR;
		var curS = startingS - x;
		# FIX Q R S
		for z in range(size):
			var tile = hexScene.instantiate();
			tile.q = curQ;
			tile.r = curR;
			tile.s = curS;
			add_child(tile);
			if x % 2 == 0:
				tile.translate(Vector3( (TILE_WIDTH) * x, 0, (0.87 * TILE_HEIGHT + 0.25) * z));
				# print("Odd Tile");
			else:
				tile.translate(Vector3( (TILE_WIDTH) * x, 0, (0.87 * TILE_HEIGHT + 0.25) * z + TILE_OFFSET));
				# print("Even Tile");
			curR += 1
			curS -= 1
		if x % 2 == 1:
			startingR -= 1
			startingS += 1


# loops through each child hex of the board and returns the hex with the given q,r,s cube coordinates
func get_tile(q, r, s):
	for tile in get_children():
		#if tile.q && tile.r && tile.s:
		if Vector3(q, r, s) == Vector3(tile.q, tile.r, tile.s):
				return tile
	var coordinate_failure = "Tile at coordinate: {str} not found"
	var specific_failure = coordinate_failure.format({"str": Vector3(q,r,s)})
	# print(specific_failure)
	return

# returns all 6 adjacent hexes to the hex tile with the inputted q,r,s cube coordinates as long as a raycast is not detecting anything above it
func get_adjacent(q, r, s, do_obstructions_matter):
	var return_array = []
	
	if do_obstructions_matter:
		if get_tile(q+1, r-1, s) && !get_tile(q+1, r-1, s).obstructed:
			get_tile(q+1, r-1, s).raymond.force_raycast_update()
			return_array.append(get_tile(q+1, r-1, s))
		if get_tile(q-1, r+1, s) && !get_tile(q-1, r+1, s).obstructed:
			get_tile(q-1, r+1, s).raymond.force_raycast_update()
			return_array.append(get_tile(q-1, r+1, s))
		if get_tile(q, r+1, s-1) && !get_tile(q, r+1, s-1).obstructed:
			get_tile(q, r+1, s-1).raymond.force_raycast_update()
			return_array.append(get_tile(q, r+1, s-1))
		if get_tile(q, r-1, s+1) && !get_tile(q, r-1, s+1).obstructed:
			get_tile(q, r-1, s+1).raymond.force_raycast_update()
			return_array.append(get_tile(q, r-1, s+1))
		if get_tile(q-1, r, s+1) && !get_tile(q-1, r, s+1).obstructed:
			get_tile(q-1, r, s+1).raymond.force_raycast_update()
			return_array.append(get_tile(q-1, r, s+1))
		if get_tile(q+1, r, s-1) && !get_tile(q+1, r, s-1).obstructed:
			get_tile(q+1, r, s-1).raymond.force_raycast_update()
			return_array.append(get_tile(q+1, r, s-1))
	
	if !do_obstructions_matter:
		if get_tile(q+1, r-1, s):
			return_array.append(get_tile(q+1, r-1, s))
		if get_tile(q-1, r+1, s):
			return_array.append(get_tile(q-1, r+1, s))
		if get_tile(q, r+1, s-1):
			return_array.append(get_tile(q, r+1, s-1))
		if get_tile(q, r-1, s+1):
			return_array.append(get_tile(q, r-1, s+1))
		if get_tile(q-1, r, s+1):
			return_array.append(get_tile(q-1, r, s+1))
		if get_tile(q+1, r, s-1):
			return_array.append(get_tile(q+1, r, s-1))
	
	return return_array

# loops through an array of tiles and returns an array that contains all unique tiles adjacent to all tiles in the array
func get_adjacents_of_array(tile_array, do_obstructions_matter):
	var return_array = []
	for tile in tile_array:
		for inner_tile in get_adjacent(tile.q, tile.r, tile.s, do_obstructions_matter):
			if !return_array.has(inner_tile) && !tile_array.has(inner_tile):
				return_array.append(inner_tile)
	return return_array

# repeats get_adjacents_of_array *distance* number of times, the furthest reached hexes reveal the maximum walking distance for a character
func get_walking_distance(q, r, s, distance, do_obstructions_matter):
	var last_step = get_adjacent(q,r,s, do_obstructions_matter)
	var origin_tile = get_tile(q,r,s)
	var current_step = []
	var return_array_of_arrays = []
	
	if distance > 0:
		for i in range(distance - 1):
			return_array_of_arrays.append(last_step)
			current_step = get_adjacents_of_array(last_step, do_obstructions_matter)
			for array_thing in return_array_of_arrays:
				for tile in array_thing:
					if current_step.has(tile):
						current_step.erase(tile)
			last_step = current_step
		return_array_of_arrays.append(last_step)
	
	for array_boy in return_array_of_arrays:
		if array_boy.has(origin_tile):
			array_boy.erase(origin_tile)
	
	for i in range(return_array_of_arrays.size()-1):
		# print(return_array_of_arrays[i])
		for tile in return_array_of_arrays[i]:
			if return_array_of_arrays[i+1].has(tile):
				return_array_of_arrays[i+1].erase(tile)
	
	var debug_movement_notification = "Can move up to %s spaces"
	var movement_notification = debug_movement_notification % distance
	# print(movement_notification)
	
	return return_array_of_arrays

# since get_walking_distance returns an array of arrays, sometimes we want just an array of tiles
func get_walking_distance_as_single_array(q, r, s, distance, do_obstructions_matter):
	var return_array = []
	var array_of_arrays = get_walking_distance(q, r, s, distance, do_obstructions_matter)
	for individual_array in array_of_arrays:
		for item in individual_array:
			return_array.append(item)
	return return_array

# returns a list of all tiles in a straight line from a givin orgin, with range *distance*, in the direction of *direction*
# options are: "north", "northeast", "northwest", "south", "southeast", "southwest"
func get_range_line(q, r, s, direction, distance, include_origin):
	var return_array = []
	
	if include_origin == true:
		if direction == "north":
			for i in range(distance+1):
				if get_tile(q,r-i,s+i):
					return_array.append(get_tile(q,r-i,s+i))
		if direction == "south":
			for i in range(distance+1):
				if get_tile(q,r+i,s-i):
					return_array.append(get_tile(q,r+i,s-i))
		if direction == "northeast":
			for i in range(distance+1):
				if get_tile(q+i,r-i,s):
					return_array.append(get_tile(q+i,r-i,s))
		if direction == "southwest":
			for i in range(distance+1):
				if get_tile(q-i,r+i,s):
					return_array.append(get_tile(q-i,r+i,s))
		if direction == "northwest":
			for i in range(distance+1):
				if get_tile(q-i,r,s+i):
					return_array.append(get_tile(q-i,r,s+i))
		if direction == "southeast":
			for i in range(distance+1):
				if get_tile(q+i,r,s-i):
					return_array.append(get_tile(q+i,r,s-i))
	
	if include_origin == false:
		if direction == "north":
			for i in range(distance+1):
				if i > 0:
					if get_tile(q,r-i,s+i):
						return_array.append(get_tile(q,r-i,s+i))
		if direction == "south":
			for i in range(distance+1):
				if i > 0:
					if get_tile(q,r+i,s-i):
						return_array.append(get_tile(q,r+i,s-i))
		if direction == "northeast":
			for i in range(distance+1):
				if i > 0:
					if get_tile(q+i,r-i,s):
						return_array.append(get_tile(q+i,r-i,s))
		if direction == "southwest":
			for i in range(distance+1):
				if i > 0:
					if get_tile(q-i,r+i,s):
						return_array.append(get_tile(q-i,r+i,s))
		if direction == "northwest":
			for i in range(distance+1):
				if i > 0:
					if get_tile(q-i,r,s+i):
						return_array.append(get_tile(q-i,r,s+i))
		if direction == "southeast":
			for i in range(distance+1):
				if i > 0:
					if get_tile(q+i,r,s-i):
						return_array.append(get_tile(q+i,r,s-i))
	
	return return_array

# returns a list of all tiles exactly *distance* steps away from the origin tile
func get_range_from_origin(q, r, s, distance):
	var return_array = []
	
	for tile in get_range_line(q, r-distance, s+distance, "southwest", distance, true):
		return_array.append(tile)
	for tile in get_range_line(q-distance, r, s+distance, "south", distance, false):
		return_array.append(tile)
	for tile in get_range_line(q-distance, r+distance, s, "southeast", distance, false):
		return_array.append(tile)
	for tile in get_range_line(q, r+distance, s-distance, "northeast", distance, false):
		return_array.append(tile)
	for tile in get_range_line(q+distance, r, s-distance, "north", distance, false):
		return_array.append(tile)
	for tile in get_range_line(q+distance, r-distance, s, "northwest", distance, false):
		return_array.append(tile)
	
	return return_array

# returns a list of all tiles in a cone from a forward direction and the two adjacent directions at range *distance*
# options are: "north", "northeast", "northwest", "south", "southeast", "southwest"
func get_range_three_cone(q, r, s, direction, distance, include_origin):
	var return_array = []
	var left_array = []
	var center_array = []
	var right_array = []
	var i = 1
	if direction == "north":
		left_array = get_range_line(q, r, s, "northwest", distance, false)
		for tile in left_array:
			return_array.append(tile)
			for tile_inner in get_range_line(tile.q, tile.r, tile.s, "northeast", i, false):
				return_array.append(tile_inner)
			i += 1
		center_array = get_range_line(q, r, s, "north", distance, include_origin)
		for tile in center_array:
			return_array.append(tile)
		right_array = get_range_line(q, r, s, "northeast", distance, false)
		i = 1
		for tile in right_array:
			return_array.append(tile)
			for tile_inner in get_range_line(tile.q, tile.r, tile.s, "northwest", i, false):
				return_array.append(tile_inner)
			i += 1
		return return_array
	
	if direction == "northeast":
		left_array = get_range_line(q, r, s, "north", distance, false)
		for tile in left_array:
			return_array.append(tile)
			for tile_inner in get_range_line(tile.q, tile.r, tile.s, "southeast", i, false):
				return_array.append(tile_inner)
			i += 1
		center_array = get_range_line(q, r, s, "northeast", distance, include_origin)
		for tile in center_array:
			return_array.append(tile)
		right_array = get_range_line(q, r, s, "southeast", distance, false)
		i = 1
		for tile in right_array:
			return_array.append(tile)
			for tile_inner in get_range_line(tile.q, tile.r, tile.s, "north", i, false):
				return_array.append(tile_inner)
			i += 1
		return return_array
	
	if direction == "southeast":
		left_array = get_range_line(q, r, s, "northeast", distance, false)
		for tile in left_array:
			return_array.append(tile)
			for tile_inner in get_range_line(tile.q, tile.r, tile.s, "south", i, false):
				return_array.append(tile_inner)
			i += 1
		center_array = get_range_line(q, r, s, "southeast", distance, include_origin)
		for tile in center_array:
			return_array.append(tile)
		right_array = get_range_line(q, r, s, "south", distance, false)
		i = 1
		for tile in right_array:
			return_array.append(tile)
			for tile_inner in get_range_line(tile.q, tile.r, tile.s, "northeast", i, false):
				return_array.append(tile_inner)
			i += 1
		return return_array
	
	if direction == "south":
		left_array = get_range_line(q, r, s, "southeast", distance, false)
		for tile in left_array:
			return_array.append(tile)
			for tile_inner in get_range_line(tile.q, tile.r, tile.s, "southwest", i, false):
				return_array.append(tile_inner)
			i += 1
		center_array = get_range_line(q, r, s, "south", distance, include_origin)
		for tile in center_array:
			return_array.append(tile)
		right_array = get_range_line(q, r, s, "southwest", distance, false)
		i = 1
		for tile in right_array:
			return_array.append(tile)
			for tile_inner in get_range_line(tile.q, tile.r, tile.s, "southeast", i, false):
				return_array.append(tile_inner)
			i += 1
		return return_array
	
	if direction == "southwest":
		left_array = get_range_line(q, r, s, "south", distance, false)
		for tile in left_array:
			return_array.append(tile)
			for tile_inner in get_range_line(tile.q, tile.r, tile.s, "northwest", i, false):
				return_array.append(tile_inner)
			i += 1
		center_array = get_range_line(q, r, s, "southwest", distance, include_origin)
		for tile in center_array:
			return_array.append(tile)
		right_array = get_range_line(q, r, s, "northwest", distance, false)
		i = 1
		for tile in right_array:
			return_array.append(tile)
			for tile_inner in get_range_line(tile.q, tile.r, tile.s, "south", i, false):
				return_array.append(tile_inner)
			i += 1
		return return_array
	
	if direction == "northwest":
		left_array = get_range_line(q, r, s, "southwest", distance, false)
		for tile in left_array:
			return_array.append(tile)
			for tile_inner in get_range_line(tile.q, tile.r, tile.s, "north", i, false):
				return_array.append(tile_inner)
			i += 1
		center_array = get_range_line(q, r, s, "northwest", distance, include_origin)
		for tile in center_array:
			return_array.append(tile)
		right_array = get_range_line(q, r, s, "north", distance, false)
		i = 1
		for tile in right_array:
			return_array.append(tile)
			for tile_inner in get_range_line(tile.q, tile.r, tile.s, "southwest", i, false):
				return_array.append(tile_inner)
			i += 1
		return return_array

# returns a list of all tiles in a cone from a foward direction and two adjacent directions at range *distance*
# options are: "east", "northeast", "southeast", "west", "northwest", "southwest"
func get_range_two_cone(q, r, s, direction, distance, include_origin):
	var return_array = []
	var left_array = []
	var right_array = []
	var i = 1
	if direction == "northeast":
		left_array = get_range_line(q, r, s, "north", distance, false)
		for tile in left_array:
			return_array.append(tile)
			for tile_inner in get_range_line(tile.q, tile.r, tile.s, "southeast", i, false):
				return_array.append(tile_inner)
			i += 1
		right_array = get_range_line(q, r, s, "northeast", distance, include_origin)
		for tile in right_array:
			return_array.append(tile)
		return return_array
	
	if direction == "east":
		left_array = get_range_line(q, r, s, "northeast", distance, false)
		for tile in left_array:
			return_array.append(tile)
			for tile_inner in get_range_line(tile.q, tile.r, tile.s, "south", i, false):
				return_array.append(tile_inner)
			i += 1
		right_array = get_range_line(q, r, s, "southeast", distance, include_origin)
		for tile in right_array:
			return_array.append(tile)
		return return_array
	
	if direction == "southeast":
		left_array = get_range_line(q, r, s, "southeast", distance, false)
		for tile in left_array:
			return_array.append(tile)
			for tile_inner in get_range_line(tile.q, tile.r, tile.s, "southwest", i, false):
				return_array.append(tile_inner)
			i += 1
		right_array = get_range_line(q, r, s, "south", distance, include_origin)
		for tile in right_array:
			return_array.append(tile)
		return return_array
	
	if direction == "southwest":
		left_array = get_range_line(q, r, s, "southwest", distance, false)
		for tile in left_array:
			return_array.append(tile)
			for tile_inner in get_range_line(tile.q, tile.r, tile.s, "southeast", i, false):
				return_array.append(tile_inner)
			i += 1
		right_array = get_range_line(q, r, s, "south", distance, include_origin)
		for tile in right_array:
			return_array.append(tile)
		return return_array
	
	if direction == "west":
		left_array = get_range_line(q, r, s, "northwest", distance, false)
		for tile in left_array:
			return_array.append(tile)
			for tile_inner in get_range_line(tile.q, tile.r, tile.s, "south", i, false):
				return_array.append(tile_inner)
			i += 1
		right_array = get_range_line(q, r, s, "southwest", distance, include_origin)
		for tile in right_array:
			return_array.append(tile)
		return return_array
	
	if direction == "northwest":
		left_array = get_range_line(q, r, s, "southwest", distance, false)
		for tile in left_array:
			return_array.append(tile)
			for tile_inner in get_range_line(tile.q, tile.r, tile.s, "north", i, false):
				return_array.append(tile_inner)
			i += 1
		right_array = get_range_line(q, r, s, "northwest", distance, include_origin)
		for tile in right_array:
			return_array.append(tile)
		return return_array

func does_los_exist(q1, r1, s1, q2, r2, s2) -> bool:
	var return_bool = true
	var first_tile = get_tile(q1, r1, s1)
	var second_tile = get_tile(q2, r2, s2)
	var raymundo = first_tile.los_finder
	raymundo.cast_to = Vector3(second_tile.get_position().x, 0, second_tile.get_position().z)
	raymundo.force_raycast_update()
	second_tile.raymond.force_raycast_update()
	if raymundo.is_colliding() && !(raymundo.get_collider() == second_tile.raymond.get_collider()):
		return_bool = false
	raymundo.cast_to = Vector3(0,0,0)
	return return_bool

# Tile color changing functions
func change_tile_color(tile, current_material):
	tile.set_material_override(current_material)

func change_list_of_tile_colors(tile_array, current_material):
	for tile in tile_array:
		var mesh_boy = tile.get_node("Circle")
		change_tile_color(mesh_boy, current_material)

func reset_board_color():
	change_list_of_tile_colors(get_children(), ORIGINAL_MATERIAL)

# Testing functions used to make sure adjacent tiles are working correctly
func test_walking_range(q, r, s, distance, do_we_want_obstructions):
	var array_thing = get_walking_distance(q, r, s, distance, do_we_want_obstructions)
	var color_array = [TEST_MATERIAL, TEST_MATERIAL_2, TEST_MATERIAL_3, TEST_MATERIAL_4]
	for i in range(distance):
		await get_tree().create_timer(0.1).timeout
		change_list_of_tile_colors(array_thing[i], color_array[i % 4])
