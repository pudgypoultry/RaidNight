extends Area3D

class_name Button3D

var mouse_in := false
var parent_object
var hex_board
var submenu_options := []

@export var button_text := ""

@onready var option_text = $ButtonText


func _ready():
	set_text(button_text)
	parent_object = self.get_parent()

# If your button is a higher-level menu button, place the hand_higher_level_menu_button_pressed() under the first if clause
# If your button should perform a specific action, place that code under handle_action_button_pressed() and put that under the first if clause
func _process(delta):
	if mouse_in && Input.is_action_just_pressed("left_mouse_click"):
		pass

# Take the option_text variable within the ButtonText object and set it to the desired string
func set_text(text_to_set):
	option_text.text = text_to_set

# When the mouse is hovering over this object, set the boolean to true
func _on_MenuButton_mouse_entered():
	mouse_in = true

# When the mouse stops hovering over this object, set the boolean to false
func _on_MenuButton_mouse_exited():
	mouse_in = false

# This is here to overwrite within inheriting scripts
func handle_action_button_pressed():
	pass

# This is here to overwrite within inheriting scripts
func handle_higher_level_menu_button_pressed():
	pass

# Loop through each subsequent child object from the furthest down one, looking upward until we find the parent Character who owns menu container
func turn_menu_off():
	# If the parent is of type Area3D
	if get_parent().get_class() == "Area3D":
		# Then if the current object this script is attached to has children objects
		if get_children().size() > 0:
			# for each item (which will always be a button) in the list of children
			for button in get_children():
				# If that button is of the same type as this object
				if button.is_class(self.get_class()):
					# Turn the visibility and functions of this button off (shut off the character's UI menu) 
					button.visible = false
					button.set_process(false)
		# Shut the parent's menu off
		get_parent().turn_menu_off()
	
	else:
		if get_children().size() > 0:
			for button in get_children():
				if button.is_class(self.get_class()):
					button.visible = false
					button.set_process(false)
		get_parent_character().turn_menu_off()
	

func get_parent_character():
	var current_parent = parent_object
	while !(current_parent is Character):
		print(current_parent)
		if current_parent:
			if current_parent.get_parent():
				current_parent = current_parent.get_parent()
	# print("Current Button's Parent:")
	# print(current_parent)
	return current_parent

func get_hex_board():
	var current_parent = get_parent_character()
	return current_parent.get_board()
	
