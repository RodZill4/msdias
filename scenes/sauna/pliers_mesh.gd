extends Node3D

func cut():
	if not $AnimationPlayer.is_playing():
		$AnimationPlayer.play("cut")
