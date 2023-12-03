extends Node3D


func _on_key_detect_body_entered(body):
	if body.has_method("get_object_type") and body.get_object_type() == "key":
		body.queue_free()
		$AnimationPlayer.play("open")
		$StaticBody3D/KeyDetect.monitoring = false
