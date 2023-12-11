extends Node3D

class_name Hexagon

@export var q : int = 0
@export var r : int = 0
@export var s : int = 0

@onready var raymond = $Raymond
@onready var los_finder = $Raymundo

var mouse_in = false
signal tile_ready_to_click(tile)

func _ready():
	pass

func _process(delta):
	if mouse_in && Input.is_action_just_pressed("left_mouse_click"):
		emit_signal("tile_ready_to_click", self)

func _on_BasicHex_mouse_entered():
	mouse_in = true

func _on_BasicHex_mouse_exited():
	mouse_in = false
