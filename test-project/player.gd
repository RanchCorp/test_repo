extends Area2D

# The following line defines a custom signal called "hit"
# The Player will emit this signal when it collides with an Enemy
# This signal can be found in the Signals tab (next to Inspector in default view)
signal hit


# Using the @export keyword allows for this variable to be adjustable in the Inspector tab
# Beware, changes made in the Inspector tab are *NOT* reflected back to this script
@export var speed = 400 # this is measured in pixels/second

var screen_size # size of the window, in pixels


####################################################################################################


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport_rect().size
	
# hide() will cause Player to be hidden when the game starts
	hide()
	
	
####################################################################################################
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	
# Initialize the velocity of the player to zero
	var velocity = Vector2.ZERO
	
	
# Input mapping can be found in Project -> Project Settings -> Input Map
# These 4 inputs were manually created there
	if Input.is_action_just_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_just_pressed("move_up"):
		velocity.y -= 1
	if Input.is_action_just_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_just_pressed("move_left"):
		velocity.x -= 1
# Note that up moves in negative direction and down moves in positive direction
# This is standard in computer graphics and game engines
	
	
# Normalizing the velocity prevents faster movement in diagonal directions
# For example pressing up and right arrows would otherwise cause you to move diagonally and
# reach (1, 1) at the same time as up arrow alone reaches (0, 1) or right arrow alone reaches (1, 0)
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
# $ is shorthand for get_node(), so the above line is the same as:
# get_node("AnimatedSprite2D").play()
# $ returns the node at the RELATIVE PATH
	
	
# position is updated after reading the velocity input
# delta refers to the amount of time that the previous frame took to complete
# clamp() restricts a value to a given range, in this case, from zero up to the size of the screen
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)
	
	
# Animations will be updated based on Player velocity
	if velocity.x != 0:
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_v = false
		$AnimatedSprite2D.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite2D.animation = "up"
		$AnimatedSprite2D.flip_v = velocity.y > 0
# flip_v and flip_h are booleans used to determine whether to reverse the image
# across the vertical or horizontal axes
	
	
####################################################################################################
	
	
func _on_body_entered(body: Node2D) -> void:
	hide() # Player disappears after being hit
	hit.emit()
	$CollisionShape2D.set_deferred("disabled", true)
# There can be errors during processing if the collision shape is changed during processing
# Using the above line tells Godot to wait to disable the shape until it is safe to do so, and also
# prevents the hit signal from being triggered more than once
	
	
####################################################################################################
	
	
# The following function is used to reset the player when starting a new game
func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
	
	


func game_over() -> void:
	pass # Replace with function body.
