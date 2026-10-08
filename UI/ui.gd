extends CanvasLayer
func update_fuel(value):
	$FuelBar.value = value
func update_score(value):
	$Score.text = "Score: " + str(value)
func update_distance(value):
	$Distance.text = "Distance: " + str(value) + "m"
