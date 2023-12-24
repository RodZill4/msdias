extends Node3D


func _on_interactable_on_action(action):
	$StaticBody3D/Key.visible = true
	$AnimationPlayer.play("open")
