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
			if tile is Hexagon:
				tile.update_obstruction()
		for tile in hexBoard.get_children():
			if tile is Hexagon:
				if tile.mouse_in == true:
					hexBoard.reset_board_color()
					currentQ = tile.q
					currentR = tile.r
					currentS = tile.s
					currentTile = hexBoard.get_tile(currentQ, currentR, currentS)
					hexBoard.test_walking_range(currentTile.q, currentTile.r, currentTile.s, 4, true)

func handle_character_clicked():
	pass
	# check to see if they're friendly or not
	# if not, just display info
	# if so, select character and show movement range
		# use handle_tile_clicked to move character to spot if clicked tile is in movement range
