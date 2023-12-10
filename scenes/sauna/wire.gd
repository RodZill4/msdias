@tool
extends Area3D


@export var color : Color:
	get:
		return color
	set(c):
		color = c
		$Wire.get_surface_override_material(0).albedo_color = color

