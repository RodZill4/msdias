extends StaticBody3D


signal ring()


func action():
	if $AudioStreamPlayer3D.playing:
		return
	$AudioStreamPlayer3D.play()
	await $AudioStreamPlayer3D.finished
	self.ring.emit()

