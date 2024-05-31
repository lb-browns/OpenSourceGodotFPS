extends GPUParticles3D
@onready var player = get_tree().get_root().get_node("Node/Player")



# Called when the node enters the scene tree for the first time.
func _ready():
	emitting = true
	var playerRotation = Vector3(player.rotation.x, player.rotation.y, player.rotation.z)
	rotation = rotation.direction_to(playerRotation)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
