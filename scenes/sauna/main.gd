extends Node3D

@export var effect_gradient_fire_death : Gradient
@export var effect_gradient_poison_death : Gradient

var xr_interface: XRInterface

var game_scene


signal effect_finished()


func _ready():
	xr_interface = XRServer.find_interface("OpenXR")
	if xr_interface and xr_interface.is_initialized():
		print("OpenXR initialized successfully")

		# Turn off v-sync!
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)

		# Change our main viewport to output to the HMD
		get_viewport().use_xr = true
	else:
		print("OpenXR not initialized, please check if your headset is connected")
	
	set_process(false)
	
	game_scene = load("res://scenes/sauna/sauna_scene.tscn").instantiate()
	add_child(game_scene)
	
	$XROrigin3D/XRHead/Music.stream = load("res://music/Spy Glass.mp3")
	$XROrigin3D/XRHead/Music.play()

@onready var died : bool = false

func die(cause : String):
	if died:
		return
	died = true
	print("Died from "+cause)
	match cause:
		"vodka fire", "excessive heat":
			start_view_effect(effect_gradient_fire_death, 5)
			await self.effect_finished
		"poison gas", "poisoned cookie":
			start_view_effect(effect_gradient_poison_death, 5)
			await self.effect_finished
		_:
			print("Unknown death "+cause)
	var new_scene = load("res://scenes/restart/restart_scene.tscn").instantiate()
	add_child(new_scene)
	game_scene.queue_free()
	game_scene = new_scene
	$XROrigin3D/XRHead/ViewEffect.visible = false
	game_scene.died(cause)
	game_scene.connect("restart", self.restart)
	
	$XROrigin3D/XRHead/Music.stream = load("res://music/I Knew a Guy.mp3")
	$XROrigin3D/XRHead/Music.play()

func restart():
	var new_scene = load("res://scenes/sauna/sauna_scene.tscn").instantiate()
	add_child(new_scene)
	game_scene.queue_free()
	game_scene = new_scene
	died = false
	
	$XROrigin3D/XRHead/Music.stream = load("res://music/Spy Glass.mp3")
	$XROrigin3D/XRHead/Music.play()

var current_effect_gradient : Gradient
var current_effect_duration : float
var current_effect_progress : float

func view_effect(g : Gradient, d : float = 1.0, keep : bool = false):
	start_view_effect(g, d)
	await self.effect_finished
	if not keep : 
		$XROrigin3D/XRHead/ViewEffect.visible = false

func start_view_effect(g : Gradient, d : float = 1.0):
	current_effect_gradient = g
	current_effect_duration = d
	current_effect_progress = 0
	$XROrigin3D/XRHead/ViewEffect.get_surface_override_material(0).albedo_color = current_effect_gradient.get_color(0)
	$XROrigin3D/XRHead/ViewEffect.visible = true
	set_process(true)

func _process(delta):
	current_effect_progress += delta
	print(current_effect_progress)
	$XROrigin3D/XRHead/ViewEffect.get_surface_override_material(0).albedo_color = current_effect_gradient.sample(current_effect_progress/current_effect_duration)
	if current_effect_progress > current_effect_duration:
		set_process(false)
		self.effect_finished.emit()
