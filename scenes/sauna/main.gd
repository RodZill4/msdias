extends Node3D


var xr_interface: XRInterface
var current_scene : Node = null


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
	
	load_scene("res://scenes/restart/restart_scene.tscn", "title")

func load_scene(scene_path : String, start_arg = null):
	var new_scene = load(scene_path).instantiate()
	add_child(new_scene)
	if current_scene:
		current_scene.queue_free()
	current_scene = new_scene
	$XROrigin3D/XRHead/ViewEffect.visible = false
	current_scene.start(start_arg)

func play_music(file_path : String):
	$XROrigin3D/XRHead/Music.stream = load(file_path)
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
	$XROrigin3D/XRHead/ViewEffect.get_surface_override_material(0).albedo_color = current_effect_gradient.sample(current_effect_progress/current_effect_duration)
	if current_effect_progress > current_effect_duration:
		set_process(false)
		self.effect_finished.emit()
