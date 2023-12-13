extends Node

@export var board : Node3D
var hexBoard : HexBoard
var currentQ = -1
var currentR = -1
var currentS = -1
var currentTile

# Called when the node enters the scene tree for the first time.
func _ready():
	hexBoard = board
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	handle_tile_clicked()

func handle_tile_clicked():

	if Input.is_action_just_pressed("left_mouse_click"):

		for tile in hexBoard.get_children():
			if tile.mouse_in == true:
				hexBoard.reset_board_color()
				currentQ = tile.q
				currentR = tile.r
				currentS = tile.s
				currentTile = hexBoard.get_tile(currentQ, currentR, currentS)
				hexBoard.test_walking_range(currentTile.q, currentTile.r, currentTile.s, 4, true)
