extends CharacterBody2D

@export var speed = 100
@export var gravity = 400
@export var jump_speed = 150
@onready var sprite = $Sprite2D

@onready var animation_tree = $AnimationTree
@onready var state_machine:AnimationTree = animation_tree

func walk(active:bool):
	state_machine["parameters/conditions/walk"] = active
	state_machine["parameters/conditions/idle"] = not active
	state_machine["parameters/conditions/attack"] = not active
	
func idle(active:bool):
	state_machine["parameters/conditions/idle"] = active
	state_machine["parameters/conditions/walk"] = not active
	
func jump(active:bool):
	state_machine["parameters/conditions/jump"] = active
	state_machine["parameters/conditions/idle"] = not active
	
func attack(active:bool):
	state_machine["parameters/conditions/attack"] = active
	await get_tree().create_timer(0.1).timeout
	state_machine["parameters/conditions/attack"] = not active

func _physics_process(delta):

	var direction = Input.get_axis("izquierda", "derecha")
	velocity.x = speed * direction
		
	if Input.is_action_just_pressed("saltar") and is_on_floor():
		jump(true)
		velocity.y -= jump_speed
	
	if velocity.y > 0:
		jump(false)
		
	if Input.is_action_just_pressed("atacar"):
		attack(true)
		
	if direction != 0:
		sprite.flip_h = direction < 0
		walk(true)
	else:
		idle(true)

	if not is_on_floor():
		velocity.y += gravity * delta

	move_and_slide()
