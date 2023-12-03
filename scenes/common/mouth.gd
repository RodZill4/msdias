extends Area3D

func _on_body_entered(body):
	if body.has_method("drink"):
		var liquid = body.drink()
		$AudioStreamPlayer3D.stream = load("res://sounds/Drink_03.wav")
		$AudioStreamPlayer3D.play
	elif body.has_method("eat"):
		var food = body.eat()
		$AudioStreamPlayer3D.stream = load("res://sounds/crunch.1.ogg")
		$AudioStreamPlayer3D.play()
		if food == "poisoned cookie":
			get_node("/root/Main").die("poisoned cookie")
