extends Node3D


@export var effect_gradient_vapor_in : Gradient
@export var effect_gradient_vapor_out : Gradient
@export var effect_gradient_fire_death : Gradient
@export var effect_gradient_poison_death : Gradient

var died : bool = false
var got_clue : bool = false

func _ready():
	get_parent().play_music("res://music/Spy Glass.mp3")

func start(arg):
	died = false

func die(cause : String):
	if died:
		return
	died = true
	print("Died from "+cause)
	match cause:
		"vodka fire", "excessive heat":
			await get_parent().view_effect(effect_gradient_fire_death, 5)
		"poison gas", "poisoned cookie":
			await get_parent().view_effect(effect_gradient_poison_death, 5)
		_:
			print("Unknown death "+cause)
	
	get_parent().load_scene("res://scenes/restart/restart_scene.tscn", cause)

func _on_stove_vapor():
	if got_clue:
		return
	got_clue = true
	await get_parent().view_effect(effect_gradient_vapor_in, 1.0, true)
	$Sauna/Wall4/Mesh/Doors.get_surface_override_material(1).roughness = 1.0
	await get_tree().create_timer(2).timeout
	await get_parent().view_effect(effect_gradient_vapor_out, 1.0)
