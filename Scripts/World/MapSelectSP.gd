extends Node
@onready var Tutorial = load("res://tscn/World/Maps/tutorial.tscn")
@onready var newRun = load("res://tscn/World/SHRooms/RoomGenTest.tscn")
@onready var MainMenu = load("res://tscn/World/Maps/mainMenu.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_tutorial_pressed():
	get_tree().change_scene_to_packed(Tutorial)


func _on_new_r_un_pressed():
	get_tree().change_scene_to_packed(newRun)


func _on_back_pressed():
	get_tree().change_scene_to_packed(MainMenu)
