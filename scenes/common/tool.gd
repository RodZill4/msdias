extends XRToolsPickable


@export var action_name : String

@onready var mesh = $Mesh
var interact_area : Area3D


func do_action(state : bool):
	if state:
		for o in $InteractArea.get_overlapping_areas():
			if o.has_method("do_action"):
				o.do_action(action_name)

func _on_interact_area_area_entered(area):
	if area.has_method("get_interaction_anchor"):
		var anchor = area.get_interaction_anchor(action_name)
		if anchor:
			remove_child(mesh)
			anchor.add_child(mesh)
			interact_area = area

func _on_interact_area_area_exited(area):
	if area == interact_area:
		mesh.get_parent().remove_child(mesh)
		add_child(mesh)
		interact_area = null

