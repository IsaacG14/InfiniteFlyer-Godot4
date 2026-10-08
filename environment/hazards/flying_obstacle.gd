extends Area3D

var fly_speed = 15.0 # How fast it flies at the player

func _process(delta):
	# Move in the positive Z direction (towards the camera/player)
	position.z += fly_speed * delta

# MAKE SURE TO CONNECT THIS SIGNAL IN THE NODE TAB!
func _on_body_entered(body: Node3D) -> void:
	# Check if the thing we hit has the die() function (the plane)
	if body.has_method("die"):
		body.die()
