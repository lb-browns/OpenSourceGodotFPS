extends Node3D
@onready var player = $"../Player"
var playerHealth : float


# Called when the node enters the scene tree for the first time.
func _ready():
	print(player)
	playerHealth = player.playerHealth

func _process(delta):
	player.playerHealth = playerHealth

func _on_area_3d_body_entered(body):
	print("butt")
	playerHealth -= 150
	print(player.playerHealth)
