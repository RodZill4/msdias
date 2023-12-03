extends Node3D


@export var effect_gradient_vapor_in : Gradient
@export var effect_gradient_vapor_out : Gradient

var got_clue : bool = false

func _on_stove_vapor():
	if got_clue:
		return
	got_clue = true
	await get_node("/root/Main").view_effect(effect_gradient_vapor_in, 1.0, true)
	$Sauna/Wall4/Mesh/Doors.get_surface_override_material(1).roughness = 1.0
	await get_tree().create_timer(2).timeout
	await get_node("/root/Main").view_effect(effect_gradient_vapor_out, 1.0)
