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
	multiplayer.peer_connected.connect(removePlayer)
	
	addPlayer(multiplayer.get_unique_id())
	
	upnp_setup()


func _on_join_pressed():
	mpMainMenu.hide()
	
	enetPeer.create_client(addressEntry.text, PORT)
	multiplayer.multiplayer_peer = enetPeer

func addPlayer(peer_id):
	var player = Player.instantiate()
	player.name = str(peer_id)
	
	add_child(player)

func removePlayer(peer_id):
	var player = get_node_or_null(str(peer_id))
	if player:
		player.queue_free()

func upnp_setup():
	var upnp = UPNP.new()
	
	var discover_result = upnp.discover()
	
	assert(discover_result == UPNP.UPNP_RESULT_SUCCESS, \
		"UPNP Discover Failed! Error %s" % discover_result)
	
	assert(upnp.get_gateway() and upnp.get_gateway().is_valid_gateway(), \
		"UPNP Invalid Gateway!")
	
	var mapResult = upnp.add_port_mapping(PORT)
	
	assert(mapResult == UPNP.UPNP_RESULT_SUCCESS, \
		"UPNP Port Mapping Failed! Error %s" % mapResult)
	
	print("Success!  Join Address: %s" % upnp.query_external_address())
