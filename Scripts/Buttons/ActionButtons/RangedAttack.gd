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
# 	turn_menu_off():
# 		sets menu_open to false, and sets the the visibility and process of the menu to false

func _ready():
	parent_object = self.get_parent_character()
	set_text(button_text)

func _process(delta):
	if mouse_in && Input.is_action_just_pressed("left_mouse_click"):
		handle_action_button_pressed()

# Get the adjacent tiles as an array, change their colors to red to indicate the attack range, and set the character's valid_action_range to that array
func handle_action_button_pressed():
	hex_board = get_hex_board()
	hex_board.reset_board_color()
	var current_tile = parent_object.get_current_tile()
	var attack_range = hex_board.get_range_from_origin(current_tile.q, current_tile.r, current_tile.s, parent_object.attack_range)
	hex_board.change_list_of_tile_colors(attack_range, parent_object.TEST_MATERIAL_4)
	parent_object.attack_damage = 2
	parent_object.allowed_to_attack = true
	parent_object.valid_action_range = attack_range
	get_parent().menu_open = false
	turn_menu_off()
