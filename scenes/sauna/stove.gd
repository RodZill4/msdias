extends StaticBody3D


var temperature : float = 30


signal vapor()


func set_temperature(t : float):
	temperature = t
	var shader_value = (temperature-30)/100
	$MeshInstance3D.get_surface_override_material(3).set_shader_parameter("temperature", shader_value)
	$MeshInstance3D.get_surface_override_material(4).set_shader_parameter("temperature", shader_value)

func on_liquid(type : String, quantity : float):
	await get_tree().create_timer(1.0).timeout
	if type == "vodka":
		explode()
	elif type == "water":
		if not $Steam.emitting:
			$Steam.emitting = true
			self.vapor.emit()

func explode():
	$Fire.emitting = true
	get_node("/root/Main").current_scene.die("vodka fire")
