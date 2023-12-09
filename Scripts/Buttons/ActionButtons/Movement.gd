extends Button3D

# Inherited variables:
# 	mouse_in - true if the mouse is currently colliding with this button's collider
# 	attached_character - the parent of this scene, set checked ready by the ready function
# 	submenu_options - exported, to be set in editor, but it's the list of buttons that should appear when this one is clicked
# 	option_text - the text that should be displayed checked this button

# Inherited functions:
# 	set_text(string)
# 		sets the text of the button
# 	_on_MenuButton_mouse_entered() and _on_MenuButton_mouse_exited():
# 		signals to determine whether the mouse is ready to select this
# 	handle_action_button_pressed():
# 		meant to be the action the button should take when pressed as long as it's not a higher-order menu button
# 	handle_higher_level_menu_button_pressed():
# 		loops through all members of submenu_options and sets their processes and visibility to true
# 	get_parent_character():
# 		loops up the chain of buttons until it finds the character all of the buttons stem from

func _ready():
	parent_object = self.get_parent_character()

func _process(delta):
	if mouse_in && Input.is_action_just_pressed("left_mouse_click"):
		handle_action_button_pressed()

# Get the adjacent tiles as an array, change their colors to red to indicate the attack range, and set the character's valid_action_range to that array
func handle_action_button_pressed():
	hex_board = get_hex_board()
	hex_board.reset_board_color()
	var current_tile = parent_object.get_current_tile()
	var movement_range = hex_board.get_walking_distance_as_single_array(current_tile.q, current_tile.r, current_tile.s, parent_object.walking_range, true)
	hex_board.change_list_of_tile_colors(movement_range, parent_object.TEST_MATERIAL_3)
	parent_object.allowed_to_move = true
	parent_object.valid_action_range = movement_range
	
	turn_menu_off()
