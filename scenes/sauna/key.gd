extends "res://scenes/common/tool.gd"


@onready var animation_player : AnimationPlayer = $Mesh/AnimationPlayer


func do_action(state : bool):
	if state:
		if animation_player.is_playing():
			return
		animation_player.play("turn")
		if interact_area:
			await animation_player.animation_finished
			drop_and_free()
	super.do_action(state)
