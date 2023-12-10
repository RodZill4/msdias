extends XRToolsPickable

@onready var mesh = $Mesh
var interact_area : Area3D

func do_action(state : bool):
	mesh.screw(state)
	if state and interact_area:
			if interact_area.has_method("screw"):
				interact_area.screw()

func _on_screw_area_area_entered(area):
	if area.has_method("get_interaction_anchor"):
		var anchor = area.get_interaction_anchor("screw")
		if anchor:
			remove_child(mesh)
			anchor.add_child(mesh)
			interact_area = area

func _on_screw_area_area_exited(area):
	if area == interact_area:
		mesh.get_parent().remove_child(mesh)
		add_child(mesh)
		interact_area = null
