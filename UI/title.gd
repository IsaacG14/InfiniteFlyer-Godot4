extends Control

# References for the animation (make sure the node names match your scene)
@onready var mini_plane = $MiniPlane
@onready var engine_sound = $EngineSound

# 3D coordinates for the flight path
var start_x = -15.0
var end_x = 15.0
var center_x = 0.0
var flight_speed = 10.0 

func _ready():
	# Your existing high score logic
	$Label2.text = "High Score: " + str(Global.high_score)
	$Label3.text = "Highest Distance: " + str(Global.high_distance)
	
	# Start the 3D plane off-screen to the left
	if mini_plane:
		mini_plane.position.x = start_x
		mini_plane.rotation_degrees.x = 15
		mini_plane.rotation_degrees.y = 20

func _process(delta):
	# Make sure the nodes exist before trying to move them
	if not mini_plane or not engine_sound: return
	
	# 1. Move the 3D plane to the right
	mini_plane.position.x += flight_speed * delta
	
	# Loop the plane back to the left if it flies off the right side
	if mini_plane.position.x > end_x:
		mini_plane.position.x = start_x
		
	# 2. Calculate the audio volume
	var distance_from_center = abs(mini_plane.position.x - center_x)
	var target_volume = remap(distance_from_center, 0.0, 15.0, 0.0, -40.0)
	
	# Apply the volume
	engine_sound.volume_db = clamp(target_volume, -40.0, 0.0)

# Your existing play button logic
func _on_texture_button_pressed():
	get_tree().change_scene_to_file("res://main.tscn")
