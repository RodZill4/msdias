extends StaticBody3D


var temperature : float = 30


signal vapor()


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

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
		$Steam.emitting = true
		self.vapor.emit()

func explode():
	$Fire.emitting = true
	get_node("/root/Main").die("vodka fire")
