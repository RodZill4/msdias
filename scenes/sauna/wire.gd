@tool
extends "res://scenes/common/tool_interactable.gd"


@export var color : Color:
	get:
		return color
	set(c):
		color = c
		set_wire_color(color)


func _ready():
	set_wire_color(color)

func set_wire_color(c : Color):
	if is_inside_tree():
		$Wire.get_surface_override_material(0).albedo_color = c

func _do_action(action : String):
	$Wire.visible = false
	$WireCut.visible = true
	$InteractArea.disabled = true
