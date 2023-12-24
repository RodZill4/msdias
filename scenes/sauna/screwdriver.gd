extends "res://scenes/common/tool.gd"


@onready var animation_player = $Mesh/AnimationPlayer


func do_action(state : bool):
	if state:
		animation_player.play("turn")
	else:
		animation_player.stop()
	super.do_action(state)
