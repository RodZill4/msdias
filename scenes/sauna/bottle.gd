@tool
extends XRToolsPickable


func _process(delta):
	var is_pouring : bool = global_transform.basis.y.y < -0.2
	$Trickle.active = is_pouring
