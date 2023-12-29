extends Node

@onready var mpMainMenu = $CanvasLayer/MainMenu
@onready var addressEntry = $CanvasLayer/MainMenu/MarginContainer/VBoxContainer/AdressEntry

const Player = preload("res://tscn/Player/player.tscn")
const PORT = 9999
var enetPeer = ENetMultiplayerPeer.new()

func _on_host_pressed():
	mpMainMenu.hide()
	
	enetPeer.create_server(PORT)
	multiplayer.multiplayer_peer = enetPeer
	multiplayer.peer_connected.connect(addPlayer)
	
	addPlayer(multiplayer.get_unique_id())


func _on_join_pressed():
	mpMainMenu.hide()
	
	enetPeer.create_client("localhost", PORT)
	multiplayer.multiplayer_peer = enetPeer

func addPlayer(peer_id):
	var player = Player.instantiate()
	player.name = str(peer_id)
	
	add_child(player)
