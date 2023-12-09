extends Character

class_name Ally

func Comments():
	"""
	signal character_selected(character)

	const TEST_MATERIAL = preload("res://Materials/test_boy_material.tres")
	const TEST_MATERIAL_2 = preload("res://Materials/test_boy_material2.tres")
	const TEST_MATERIAL_3 = preload("res://Materials/test_boy_material3.tres")
	const TEST_MATERIAL_4 = preload("res://Materials/test_boy_material4.tres")
	const TEST_MATERIAL_5 = preload("res://Materials/test_boy_material5.tres")

	@onready var hp_label = $HPLabel
	@onready var rayman = $Rayman
	@onready var menu_container = $MenuContainerTest

	@export var influence_range := 5
	@export var attack_range := 4
	@export var current_health := 30
	@export var walking_range = 6

	var mouse_in := false
	var attack_damage = 3
	var ranged_damage = 2
	var height_offset := 1.5
	var allowed_to_attack := false
	var allowed_to_move := false
	var menu_open := false
	var valid_action_range := []
	var hp_label_base_text := "Current HP:\n %s"
	"""

@onready var menu_container = $MenuContainerTest

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _process(delta):
	if mouse_in && Input.is_action_just_pressed("left_mouse_click") && !menu_open:
		turn_menu_on()
		emit_signal("character_selected", self)
	
	hp_label.text = hp_label_base_text % current_health
	# hp_label.look_at(-$"../Camera3D".transform.origin, Vector3(0,1,0))

func turn_menu_off():
	menu_container.visible = false
	menu_container.set_process(false)
	menu_open = false

func turn_menu_on():
	menu_container.visible = true
	menu_container.set_process(true)
	menu_open = true

func get_current_tile():
	rayman.force_raycast_update()
	# print(rayman.get_collider())
	return rayman.get_collider()

func get_board():
	# print(get_current_tile().get_parent())
	return get_current_tile().get_parent()

func _on_Character_mouse_entered():
	mouse_in = true

func _on_Character_mouse_exited():
	mouse_in = false

