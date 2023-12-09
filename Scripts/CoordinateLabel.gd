extends Label3D

func _ready():
	var parent_node = get_parent()
	var q = parent_node.q
	var r = parent_node.r
	var s = parent_node.s
	var coordinate_text := "q: %s \nr: %s \ns: %s"
	var label_text = coordinate_text % [q, r, s]
	set_text(label_text)
