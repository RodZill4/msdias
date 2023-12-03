extends XRToolsPickable

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func do_action(state : bool):
	if state:
		$AnimationPlayer.play("turn")
		for o in $ScrewArea.get_overlapping_areas():
			if o.has_method("screw"):
				o.screw()
	else:
		$AnimationPlayer.stop()
