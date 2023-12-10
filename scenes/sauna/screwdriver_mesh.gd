extends Node3D

func screw(state : bool):
	if state:
		$AnimationPlayer.play("turn")
	else:
		$AnimationPlayer.stop()
