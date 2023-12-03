extends Node3D


signal restart()


func _on_bell_ring():
	self.restart.emit()
