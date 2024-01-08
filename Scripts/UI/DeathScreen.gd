extends Control
@onready var mainMenu = load("res://tscn/World/Maps/mainMenu.tscn")
@onready var newRun = load("res://tscn/World/SHRooms/RoomGenTest.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_new_run_pressed():
	get_tree().change_scene_to_packed(newRun)
