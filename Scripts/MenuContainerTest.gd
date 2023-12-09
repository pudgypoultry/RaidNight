extends Node3D

var camera

func _ready():
	camera = get_node("/root/Main/CameraControl/Camera3D")
	pass

func _process(delta):
	look_at(Vector3(camera.global_translation.x, -camera.global_translation.y, camera.global_translation.z), Vector3(0,-1,0))
	pass
