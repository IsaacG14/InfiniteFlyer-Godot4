extends Area3D

var move_x = false
var move_y = false
var move_amount = 2.5
var move_speed = 2.0

func _ready():
	$Label3D.hide()
	var tween = create_tween().set_loops().set_trans(Tween.TRANS_SINE)
	tween.stop()
	if move_y:
		tween.tween_property($CollisionShape3D, "position:y", -move_amount, move_speed)
		tween.tween_property($CollisionShape3D, "position:y", move_amount, move_speed)
		tween.play()
	if move_x:
		tween.tween_property($CollisionShape3D, "position:x", -move_amount, move_speed)
		tween.tween_property($CollisionShape3D, "position:x", move_amount, move_speed)
		tween.play()

func _process(delta):
	$CollisionShape3D/MeshInstance3D.rotate_y(deg_to_rad(50) * delta)

# Make sure this signal is connected in the Node tab!
func _on_body_entered(body: Node3D) -> void:
	$CollisionShape3D/MeshInstance3D.hide()
	
	# Increase the plane's speed by 2
	body.forward_speed += 3.0 
	
	$Label3D.text = "SPEED UP!"
	$Label3D.modulate = Color(0, 1, 1) # Cyan text
	$Label3D.show()
	
	var tween = create_tween().set_parallel()
	tween.tween_property($Label3D, "position", Vector3(0, 10, 0), 1.0)
	tween.tween_property($Label3D, "modulate:a", 0.0, 0.5)
