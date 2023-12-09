extends Node3D

var camera_speed = .5
var camera_scroll_speed = 0.7
var camera_move_speed = .4
var mouse_delta = Vector2()
var move_forward = false
var move_back = false
var move_left = false
var move_right = false

@onready var cam_reference = $"../CameraReference"

func _ready():
	print(cam_reference)

func _input(event):
  
	if event is InputEventMouseMotion && Input.is_action_pressed("right_mouse_click"):
		mouse_delta = event.relative
	
	if Input.is_action_pressed("scroll_wheel_up"):
		translate_object_local(camera_scroll_speed * Vector3(0,0,-1))
	
	if Input.is_action_pressed("scroll_wheel_down"):
		translate_object_local(camera_scroll_speed * Vector3(0,0, 1))
	
	if Input.is_action_just_pressed("camera_right"):
		move_right = true
	
	if Input.is_action_just_released("camera_right"):
		move_right = false
	
	if Input.is_action_just_pressed("camera_left"):
		move_left = true
	
	if Input.is_action_just_released("camera_left"):
		move_left = false
	
	if Input.is_action_just_pressed("camera_forward"):
		move_forward = true
	
	if Input.is_action_just_released("camera_forward"):
		move_forward = false
	
	if Input.is_action_just_pressed("camera_back"):
		move_back = true
	
	if Input.is_action_just_released("camera_back"):
		move_back = false

func _process(delta):
	# camera rotation and reset
	rotation.x -= mouse_delta.y * camera_speed * delta
	rotation.y -= mouse_delta.x * camera_speed * delta
	cam_reference.rotation.y -= mouse_delta.x * camera_speed * delta
	# print(cam_reference.rotation)
	mouse_delta = Vector2()
	
	
	if move_right:
		translate_object_local(camera_move_speed * Vector3(1,0,0))
	
	if move_left:
		translate_object_local(camera_move_speed * Vector3(-1,0,0))
	
	if move_forward:
		position += camera_move_speed * -Vector3(cam_reference.transform.basis.z.x, 0, cam_reference.transform.basis.z.z)
	
	if move_back:
		position += camera_move_speed * Vector3(cam_reference.transform.basis.z.x, 0, cam_reference.transform.basis.z.z)
	

