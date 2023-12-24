@tool
extends Node3D


@export var show_tool : bool:
	get:
		return show_tool
	set(s):
		show_tool = s
		if Engine.is_editor_hint():
			set_tool(tool_scene)
@export var tool_scene : PackedScene:
	get:
		return tool_scene
	set(s):
		tool_scene = s
		if Engine.is_editor_hint():
			set_tool(tool_scene)


func _ready():
	if Engine.is_editor_hint():
		set_tool(tool_scene)

func set_tool(s : PackedScene):
	clear_gizmos()
	if show_tool and s:
		var gizmo = load("res://scenes/common/tool_interactable_anchor_gizmo.gd").new(s)
		gizmo.set_node_3d(self)
		add_gizmo(gizmo)
