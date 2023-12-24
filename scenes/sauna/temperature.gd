extends Node3D

@export var stove_path : NodePath

var temperature : float = 30.0
var increase : float = 2.0

@onready var stove = get_node(stove_path)

# Called when the node enters the scene tree for the first time.
func _ready():
	stove.vapor.connect(self.on_vapor)

func angle_from_temperature(t : float) -> float:
	return -36.8+(t-30)*(138+36.8)/(110-30)

func _on_screw_area_on_action(action):
	increase = -5.0

func get_interaction_anchor(action : String):
	return $ScrewdriverAnchor

func on_vapor():
	temperature -= 5
	if temperature < 30:
		temperature = 30

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	temperature += increase*delta
	stove.set_temperature(temperature)
	if temperature < 30.0:
		temperature = 30
		if increase < 0:
			set_process(false)
			get_node("/root/Main").current_scene.die("")
	elif temperature > 140.0:
		set_process(false)
		get_node("/root/Main").current_scene.die("excessive heat")
	$Pivot.rotation_degrees.x = angle_from_temperature(temperature)
