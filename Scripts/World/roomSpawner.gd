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
	
	

func _input(event):
	if event.is_action_pressed("Interact"):
		removeCurrentRoom()
		
		createNewRoom()
	

func removeCurrentRoom():
	currRoom = get_tree().get_nodes_in_group("Room")
	remove_child(currRoom[0])

func createNewRoom():
	add_child(newRoom)
	playerSpawn = get_node("Node/Player_Spawn")
	player.position = playerSpawn.transform.origin
	print(playerSpawn.transform.origin)
	print(newRoom)
