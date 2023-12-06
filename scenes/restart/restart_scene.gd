extends Node3D


signal restart()

func _ready():
	get_parent().play_music("res://music/I Knew a Guy.mp3")

func start(cause : String):
	$Message.died(cause)

func _on_bell_ring():
	get_parent().load_scene("res://scenes/sauna/sauna_scene.tscn", null)
