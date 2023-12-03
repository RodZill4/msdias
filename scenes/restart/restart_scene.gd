extends Node3D


signal restart()

func died(cause : String):
	$Message.died(cause)

func _on_bell_ring():
	self.restart.emit()
