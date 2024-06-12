extends CanvasLayer
@onready var player = $".."
@onready var healthText = $"VBoxContainer/Panel/Upgrade Health/Label"

# Called when the node enters the scene tree for the first time.
func _ready():
	healthText.text = str(player.playerMaxHealth)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	healthText.text = str(player.playerMaxHealth)
