extends CharacterBody2D

@export var speed = 100
@export var gravity = 400
@export var jump_speed = 150
@onready var sprite = $Sprite2D
@onready var animation_player = $AnimationPlayer
@onready var label = $Label
@onready var label2 = $Label2

var is_jumping = false
var is_attacking = false

func _physics_process(delta):

	var direction = Input.get_axis("izquierda", "derecha")
	velocity.x = speed * direction
	
	if not is_on_floor():
		velocity.y += gravity * delta
		
	if Input.is_action_just_pressed("saltar") and not is_jumping and not is_attacking:
		is_jumping = true
		velocity.y -= jump_speed
		animation_player.play("jump")
	elif is_jumping and is_on_floor():
		is_jumping = false
		
	if Input.is_action_just_pressed("atacar") and not is_jumping:
		is_attacking = true
		animation_player.play("attack")
		await get_tree().create_timer(0.8).timeout
		is_attacking = false
		
	if direction != 0:
		sprite.flip_h = direction < 0
		if not is_jumping and not is_attacking: animation_player.play("walk")
	else:
		if not is_jumping and not is_attacking: animation_player.play("idle")
	
	label2.text = "saltando: %s" % is_jumping
	label.text = "esta atacando: %s" % is_attacking
	
	move_and_slide()
