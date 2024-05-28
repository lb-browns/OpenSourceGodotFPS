extends Node

@onready var player = %Player
@onready var playerSpawn = get_node("Node/Player_Spawn")
@onready var exfil = get_node("Node/Exfil")
@export var Rooms = []
var room
var newRoom
var currRoom

func _ready():
	exfil.CHANGESCENE.connect(roomGen)
	roomRand()
	



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
