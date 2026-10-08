extends Node3D

var ground_scene = preload("res://environment/buildings/ground_segment.tscn")

var buildings = [
	preload("res://environment/buildings/building_1.tscn"),
	preload("res://environment/buildings/building_2.tscn"),
	preload("res://environment/buildings/building_3.tscn"),
	preload("res://environment/buildings/building_4.tscn"),
	preload("res://environment/buildings/building_5.tscn"),
]
var ring = preload("res://environment/pick_ups/ring.tscn")
var boost_ring_scene = preload("res://environment/pick_ups/boost_ring.tscn")
var obstacle_scene = preload("res://environment/hazards/flying_obstacle.tscn")
var level = 0

func _on_visible_on_screen_notifier_3d_screen_exited():
	queue_free()

func _ready():
	add_ground()
	add_buildings()
	add_center_buildings()
	add_rings()
	add_obstacles()

# --- NEW: Mathematical Curve function ---
func get_curve_offset(local_z: float) -> float:
	# Combine the chunk's position with the object's local position
	var global_z = position.z + local_z
	
	# A sine wave naturally curves back and forth.
	# / 150.0 controls how long and drawn out the turns are.
	# * 35.0 controls how far left/right the curves swing.
	return sin(global_z / 150.0) * 35.0

func add_buildings():
	for side in [-1, 1]:
		var zpos = -10.0
		for i in 18:
			if randf() > 0.75:
				zpos -= randi_range(5, 10)
				continue
			var nb = buildings[randi_range(0, buildings.size()-1)].instantiate()
			add_child(nb)
			
			nb.transform.origin.z = zpos
			
			# Shift the building left or right based on the curve!
			var curve_shift = get_curve_offset(zpos)
			nb.transform.origin.x = (20 * side) + curve_shift
			
			zpos -= nb.get_node("MeshInstance3D").mesh.get_aabb().size.z
			
func add_center_buildings():
	if level > 0:
		for z in range(0, -200, -20):
			if randf() > 0.8:
				var nb = buildings[0].instantiate()
				add_child(nb)
				nb.position.z = z
				
				# Shift center buildings to follow the curve
				nb.position.x = 8 + get_curve_offset(z)
				nb.rotation.y = PI / 2

func add_rings():
	var zpos = -15.0 
	
	while zpos > -200.0:
		var nr
		
		# 15% chance to spawn a boost ring instead of a normal one
		if randf() > 0.85:
			nr = boost_ring_scene.instantiate()
		else:
			nr = ring.instantiate()
			
		nr.position.z = zpos
		nr.position.y = randf_range(3, 17)
		
		# Base the ring's X position on the center of the curve
		var base_x = get_curve_offset(zpos)
		nr.position.x = base_x
		
		match level:
			0: pass
			1:
				nr.move_y = true
			2:
				nr.position.x = base_x + randf_range(-10, 10)
				nr.move_y = true
			3:
				nr.position.x = base_x + randf_range(-10, 10)
				nr.move_x = true
				
		add_child(nr)
		zpos -= randf_range(25.0, 45.0)

func add_ground():
	var zpos = 0.0
	
	# Step by 10 units (matching the length of the ground mesh we made)
	while zpos > -200.0:
		var tile = ground_scene.instantiate()
		add_child(tile)
		
		tile.position.z = zpos
		tile.position.y = 0 # Or whatever your ground height is
		
		# Shift the floor left/right using the exact same curve as the buildings!
		tile.position.x = get_curve_offset(zpos)
		
		zpos -= 10.0
		
func add_obstacles():
	# Give the player a break: don't spawn obstacles on the very first level
	if level < 1: 
		return

	var zpos = -30.0 
	
	while zpos > -200.0:
		# 40% chance to spawn an obstacle here
		if randf() > 0.6: 
			var obs = obstacle_scene.instantiate()
			add_child(obs)
			
			obs.position.z = zpos
			# Random height in the playable area
			obs.position.y = randf_range(4.0, 16.0)
			
			# Shift it to match the winding curve, plus a tiny random offset
			# so they aren't always perfectly dead center
			var base_x = get_curve_offset(zpos)
			obs.position.x = base_x + randf_range(-8.0, 8.0)
			
		# Space them out so the player has time to react
		zpos -= randf_range(30.0, 50.0)
