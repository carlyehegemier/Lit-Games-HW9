extends CharacterBody2D
var gravity : Vector2
@export var jump_height : float ## How high should they jump?
@export var movement_speed : float ## How fast can they move?
@export var horizontal_air_coefficient : float ## Should the player move more slowly left and right in the air? Set to zero for no movement, 1 for the same
@export var speed_limit : float ## What is the player's max speed? 
@export var friction : float ## What friction should they experience on the ground?

# Called when the node enters the scene tree for the first time.
func _ready():
	gravity = Vector2(0, 100)
	pass # Replace with function body.


func _get_input():
	if is_on_floor(): # Check if character is on the floor
		if Input.is_action_pressed("move_left"): # if the 'A' Button is pressed, adjusts velocity moving the character left
			velocity += Vector2(-movement_speed,0)

		if Input.is_action_pressed("move_right"): # if the 'D' Button is pressed, adjusts velocity moving the character right 
			velocity += Vector2(movement_speed,0)

		if Input.is_action_just_pressed("jump"): # Jump only happens when we're on the floor (unless we want a double jump, but we won't use that here)
			velocity += Vector2(1,-jump_height)

	if not is_on_floor(): # Checks if the character is not on the floor
		if Input.is_action_pressed("move_left"): # if the 'A' Button is pressed, adjusts velocity moving the character left while factoring in 'physics' of friction/air
			velocity += Vector2(-movement_speed * horizontal_air_coefficient,0)

		if Input.is_action_pressed("move_right"): # if the 'D' Button is pressed, adjusts velocity moving the character right while factoring in 'physics' of friction/air
			velocity += Vector2(movement_speed * horizontal_air_coefficient,0)

func _limit_speed(): # hold the x speed to bounds 
	if velocity.x > speed_limit: # if the x speed is above the limit in the positive direction, then reset it so its the limit 
		velocity = Vector2(speed_limit, velocity.y)

	if velocity.x < -speed_limit: # if the x speed is above the limit in the negative direction, then reset it to the limit 
		velocity = Vector2(-speed_limit, velocity.y)

func _apply_friction():
	if is_on_floor() and not (Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right")): # if the Godotbot is on the floor and no keys are being pressed, friction is applied until it stops
		velocity -= Vector2(velocity.x * friction, 0)
		if abs(velocity.x) < 5:
			velocity = Vector2(0, velocity.y) # if the velocity in x gets close enough to zero, we set it to zero

func _apply_gravity(): # adds the physics of gravity
	if not is_on_floor(): # if the Godotbot is not on the floor, add gravity so it falls down 
		velocity += gravity

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	_get_input()
	_limit_speed()
	_apply_friction()
	_apply_gravity()

	move_and_slide()
	pass
