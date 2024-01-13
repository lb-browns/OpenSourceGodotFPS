extends Node

@onready var player = %Player
@onready var playerSpawn = get_node("Node/Player_Spawn")
@onready var exfil = get_node("Node/Exfil")
var Rooms = [
	preload("res://tscn/World/SHRooms/Room1dev.tscn"),
	preload("res://tscn/World/SHRooms/WareHouse2.tscn"),
	preload("res://tscn/World/SHRooms/room_1_warehouse.tscn"),
	preload("res://tscn/World/SHRooms/Room2dev.tscn") 
]
var room
var newRoom
var currRoom

func _ready():
	exfil.CHANGESCENE.connect(roomGen)
	roomRand()
	

func _input(event):
	
	if event.is_action_pressed("Interact"):
		roomRand()
		
		removeCurrentRoom()
		
		createNewRoom()
	

func removeCurrentRoom():
	
	currRoom = get_tree().get_nodes_in_group("Room")
	remove_child(currRoom[0])


func createNewRoom():
	
	add_child(newRoom)
	playerSpawn = get_node("Node/Player_Spawn")
	player.position = playerSpawn.transform.origin
	exfil = get_node("Node/Exfil")
	exfil.CHANGESCENE.connect(roomGen)
	print(playerSpawn.transform.origin)
	print(newRoom)
	print(exfil)

func roomRand():
	
	randomize()
	var x = randi() % Rooms.size()
	
	room = Rooms[x]
	newRoom = room.instantiate()

func roomGen():
	roomRand()
		
	removeCurrentRoom()
		
	createNewRoom()
