extends RigidBody2D


func _ready() -> void:
	var mob_types = Array($AnimatedSprite2D.sprite_frames.get_animation_names())
	$AnimatedSprite2D.animation = mob_types.pick_random()
	$AnimatedSprite2D.play()
# The above creates an Array containing the 3 Mob animations (fly, swim, walk)
	
	
	
func _process(delta: float) -> void:
	pass
	
	
	
func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
# The above connects to a Signal that emits when Mob leaves the screen
# queue_free() is a function that deletes the node at the end of the frame
	
	
