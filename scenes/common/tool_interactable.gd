@tool
extends Area3D


@export var action_name : String
@export var signal_delay : float = 0.0


signal on_action(action : String)


func _do_action(action : String) -> bool:
	if signal_delay > 0.0:
		var timer : SceneTreeTimer = get_tree().create_timer(signal_delay)
		timer.timeout.connect(self.do_emit_signal)
	else:
		do_emit_signal()
	return false

func do_emit_signal():
	on_action.emit(action_name)

func do_action(action : String) -> bool:
	if action == action_name:
		return _do_action(action)
	return false

func get_interaction_anchor(action : String) -> Node3D:
	if action == action_name:
		return $ToolAnchor
	return null
