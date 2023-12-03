extends MeshInstance3D


# Called when the node enters the scene tree for the first time.
func _ready():
	# Hook the highlight update
	get_parent().connect("highlight_updated", _on_highlight_updated)

# Called when the pickable highlight changes
func _on_highlight_updated(_pickable, enable: bool) -> void:
	if enable:
		material_overlay = preload("res://scenes/common/highlight.tres")
	else:
		material_overlay = null
