@tool
extends EditorNode3DGizmo

var meshes : Array

func _init(tool_scene : PackedScene):
	var tool_instance = tool_scene.instantiate()
	meshes = []
	var t : Transform3D = Transform3D()
	add_meshes(tool_instance.get_node("Mesh"), t)
	tool_instance.free()
	set_hidden(false)

func _redraw():
	clear()
	for m in meshes:
		add_mesh(m.mesh, null, m.transform)

func add_meshes(node : Node, t : Transform3D):
	if not node:
		return
	if node is Node3D:
		t *= node.transform
		if node is MeshInstance3D:
			meshes.append({mesh=node.mesh, transform=t})
	for c in node.get_children():
		add_meshes(c, t)
