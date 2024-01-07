extends Node
@onready var player = $Player
@onready var playerSpawn = get_node("Node/Player_Spawn")
var Rooms = [
	preload("res://tscn/World/SHRooms/Room1dev.tscn"),
	preload("res://tscn/World/SHRooms/Room2dev.tscn") 
]
var room
var newRoom
var currRoom

func _process(delta):
	randomize()
	var x = randi() % Rooms.size()
	
	room = Rooms[x]
	newRoom = room.instantiate()
	
	playerSpawn = get_node("Node/Player_Spawn")
	

func _input(event):
	if event.is_action_pressed("Jump"):
		currRoom = get_tree().get_nodes_in_group("Room")
		remove_child(currRoom[0])
		add_child(newRoom)
		
		player.position = playerSpawn.transform.origin
		print(playerSpawn.transform.origin)
		print(newRoom)
