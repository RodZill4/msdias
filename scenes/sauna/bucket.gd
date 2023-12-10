@tool
extends XRToolsPickable


var liquid_level : float = 0.0:
	get:
		return liquid_level
	set(v):
		liquid_level = v
		$Mesh.get_surface_override_material(1).set_shader_parameter("liquid_level", liquid_level+MIN_LIQUID_LEVEL)

@onready var trickle = $Trickle


const MIN_LIQUID_LEVEL : float = 0.08


func on_liquid(type : String, quantity : float):
	if  (global_transform.basis.y.y < 0.5):
		return
	liquid_level += quantity*0.1
	if liquid_level > 0.5:
		liquid_level = 0.5
	trickle.liquid_type = type

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var is_pouring : bool = (global_transform.basis.y.y < -0.2) and (liquid_level > 0)
	trickle.active = is_pouring
	if is_pouring:
		liquid_level -= 0.01*delta
		if liquid_level < 0.0:
			liquid_level = 0.0
		
