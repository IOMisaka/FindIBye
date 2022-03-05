extends CanvasLayer

func _ready():
	pass
	
func _input(event):
	if event is InputEventMouseButton:
		if event.pressed == true:
			$MouseParticle.emitting = true
		else:
			$MouseParticle.emitting = false
	if event is InputEventMouseMotion:
		$MouseParticle.position = event.position
	pass
