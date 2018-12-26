extends RigidBody2D

export (int) var MIN_SPEED
export (int) var MAX_SPEED

var mob_types = ["fly", "swim", "walk"]


func _ready():
	$AnimatedSprite.animation = mob_types[randi() % mob_types.size()]  # choose random mob type
	
	



func _on_VisibilityNotifier2D_screen_exited():
	# called when the mob node exits the screen
	queue_free()  # delete the mob node
