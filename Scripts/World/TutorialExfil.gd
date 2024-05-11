extends Node

@onready var mainMenu = preload("res://tscn/World/Maps/mainMenu.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	get_tree().change_scene_to_packed(mainMenu)
