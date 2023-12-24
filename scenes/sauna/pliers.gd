extends "res://scenes/common/tool.gd"


@onready var animation_player = $Mesh/AnimationPlayer


func do_action(state : bool):
	if state:
		if animation_player.is_playing():
			return
		animation_player.play("cut")
	super.do_action(state)
