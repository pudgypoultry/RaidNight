extends Node3D

var test_movement_origin
var test_movement_target
var test_selected_tile := Vector3()
var test_walking_options := []
var selecting_character := false
var rng = RandomNumberGenerator.new()
var last_selected_character
var allowed_to_attack = false

@onready var hex_grid = $CreatedBoard
@onready var test_character = $Ally
@onready var test_enemy = $Enemy
# onready var test_enemy = $Enemy

const ORIGINAL_MATERIAL = preload("res://Materials/BasicHexMaterial.tres")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	test_character.connect("character_selected",Callable(self,"handle_character_selected"))
	test_enemy.connect("character_selected",Callable(self,"handle_character_selected"))
	var current_tile
	for tile in hex_grid.get_children():
		current_tile = tile
		current_tile.connect("tile_ready_to_click",Callable(self,"handle_tile_clicked"))
	"""
	# These are needed to subscribe to the necessary signals
	var current_tile
	test_character.connect("character_ready_to_click",Callable(self,"handle_character_clicked"))
	# test_enemy.connect("character_ready_to_click",Callable(self,"handle_character_clicked"))
	"""



# Handles the subscribed signal from each tile to know when its collider is clicked
func handle_tile_clicked(current_tile):
	if last_selected_character:
		if last_selected_character.allowed_to_move:
			last_selected_character.position = Vector3(current_tile.get_position().x, test_character.height_offset, current_tile.get_position().z)
			last_selected_character.allowed_to_move = false
			hex_grid.reset_board_color()
	"""
	current_tile.raymond.force_raycast_update()
	if current_tile.raymond.is_colliding():
		if current_tile.raymond.get_collider().is_in_group("Enemies") && Input.is_action_just_pressed("left_mouse_click"):
			handle_character_clicked(current_tile.raymond.get_collider())
			return
	
	if Input.is_action_just_pressed("left_mouse_click"):
		if test_walking_options.has(current_tile):
			var current_height = test_character.get_position().y
			test_character.position = Vector3(current_tile.get_position().x, test_character.height_offset, current_tile.get_position().z)
			test_walking_options = []
			test_hexgrid.change_list_of_tile_colors(test_hexgrid.get_children(), ORIGINAL_MATERIAL)
			selecting_character = false
	"""

# Handles the subscribed signal from each character to know when its collider is clicked
func handle_character_selected(current_character):
	if last_selected_character:
		if last_selected_character != current_character:
			if last_selected_character.allowed_to_attack && current_character is Enemy:
				if current_character.get_current_tile() in last_selected_character.valid_action_range:
					current_character.current_health = current_character.current_health - last_selected_character.attack_damage
					last_selected_character.allowed_to_attack = false
					hex_grid.reset_board_color()
	last_selected_character = current_character
	
	"""
	if Input.is_action_pressed("left_mouse_click") && current_character.is_in_group("Enemies"):
		# print(current_character)
		if allowed_to_attack:
			current_character.current_health -= last_selected_character.attack_damage
			# print("Attack Completed")
			allowed_to_attack = false
	
	if Input.is_action_just_pressed("left_mouse_click") && current_character.is_in_group("PlayerCharacter"):
		last_selected_character = current_character
		var current_tile = current_character.rayman.get_collider()
		var random_int = rng.randi_range(1, 6)
		test_walking_options = test_hexgrid.get_walking_distance_as_single_array(current_tile.q, current_tile.r, current_tile.s, 6, true)
		# test_hexgrid.test_walking_range(current_tile.q, current_tile.r, current_tile.s, random_int)
		selecting_character = true
		if !allowed_to_attack:
			allowed_to_attack = true
			# print("Attack Allowed")
	
	if Input.is_action_just_pressed("left_mouse_click") && selecting_character && current_character != last_selected_character:
		pass
	"""


# Testing functions
func test_walking_distance_from_character():
	pass
	"""
	test_character.rayman.force_raycast_update()
	print(test_character.rayman.is_colliding())
	print(test_character.rayman.get_collider())
	if test_character.rayman.is_colliding():
		test_movement_origin = test_character.rayman.get_collider()
		test_hexgrid.test_walking_range(test_movement_origin.q, test_movement_origin.r, test_movement_origin.s, 5, true)
	"""

func Comments():
	"""
	handle_character_clicked requirements:
		If character is a friend:
			set last_clicked_character as our boy
			✓ bring up rudimentary menu
			Options are move or attack
			if move:
				call for walking distance and color those tiles
				if the next click is inside of a tile within that range:
					move there
				otherwise:
					clear that array and reset to neutral state
			if attack:
				bring up attack options "Spell" and "Physical" that demonstrate two options for attack ranges
				if spell:
					walls don't matter
				if physical:
					walls do matter
		
		If character is an enemy:
			If last_character_clicked is friend && last_character_clicked can attack AND I'm in range:
				hit me
		
			If no last_clicked_character:
				bring up my stats or description
	"""
