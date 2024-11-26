extends CharacterBody2D

@export var speed = 100
@export var gravity = 400
@export var jump_speed = 150
@onready var sprite = $Sprite2D
@onready var animation_player = $AnimationPlayer
@onready var label = $Label
#@onready var label2 = $Label2

enum STATE {
	IDLE, WALK, JUMP, FALL, ATTACK
}
var current_state:STATE = STATE.IDLE

func _physics_process(delta):
	
	match current_state:
		STATE.IDLE:
			
			velocity.x = 0
			animation_player.play("idle")
			
			if Input.is_action_pressed("izquierda") or Input.is_action_pressed("derecha"):
				current_state = STATE.WALK
			elif Input.is_action_just_pressed("saltar"):
				current_state = STATE.JUMP
			elif Input.is_action_just_pressed("atacar"):
				current_state = STATE.ATTACK
				
		STATE.WALK:
			
			velocity.x =  Input.get_axis("izquierda", "derecha") * speed
			if velocity.x < 0:
				sprite.flip_h = true
			elif velocity.x > 0:
				sprite.flip_h = false
			animation_player.play("walk")
			
			if Input.is_action_just_pressed("saltar"):
				current_state = STATE.JUMP
			elif Input.is_action_just_pressed("atacar"):
				current_state = STATE.ATTACK
			elif not Input.is_action_pressed("izquierda") and not Input.is_action_pressed("derecha"):
					current_state = STATE.IDLE
					
		STATE.JUMP:
			animation_player.play("jump")
			if is_on_floor():
				velocity.y -= jump_speed
				
			if velocity.y >= 0:
				current_state = STATE.FALL
			
		STATE.FALL:
			if is_on_floor():
				current_state = STATE.IDLE
				
		STATE.ATTACK:
			velocity.x = 0
			animation_player.play("attack")

	if not is_on_floor():
		velocity.y += gravity * delta
	
	label.text = "estado actual: %s" % STATE.keys()[current_state]
	
	move_and_slide()

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "attack":
		current_state = STATE.IDLE
