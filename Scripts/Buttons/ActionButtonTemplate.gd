extends Button3D

# variables:
# 	mouse_in - true if the mouse is currently colliding with this button's collider
# 	attached_character - the parent of this scene, set checked ready by the ready function
# 	submenu_options - exported, to be set in editor, but it's the list of buttons that should appear when this one is clicked
# 	option_text - the text that should be displayed checked this button

# functions:
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

func handle_action_button_pressed():
	pass
