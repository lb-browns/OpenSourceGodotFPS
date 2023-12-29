extends Node3D

var mouseMov
var swayThreshHold = 5
var swayLerp = 5

@export var swayLeft : Vector3
@export var swayRight : Vector3
@export var swayNormal : Vector3

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _input(event):
	if event is InputEventMouseMotion:
		
		mouseMov = -event.relative.x

func _proccess(delta):
	if mouseMov != null:
		print("mousemov true")
		if mouseMov > swayThreshHold:
			print("mousemov left")
			rotation = rotation.lerp(swayLeft, swayLerp * delta)
		elif mouseMov < -swayThreshHold:
			rotation = rotation.lerp(swayRight, swayLerp * delta)
		else:
			rotation = rotation.lerp(swayNormal, swayLerp * delta)
