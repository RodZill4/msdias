extends XRToolsPickable


@onready var mesh = $Mesh


func do_action(state : bool):
	if state:
		mesh.cut()
		for o in $CutArea.get_overlapping_areas():
			if o.has_method("cut"):
				o.screw()
