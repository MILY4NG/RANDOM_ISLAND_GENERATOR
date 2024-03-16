extends KinematicBody2D

const MAX_SPEED = 20

const SPEED = 100
const TILESIZE = 150

var movement = Vector2()
var xmoved = false
var ymoved = false

var isdown = true
var isright = true

onready var anim = $AnimationPlayer
onready var sprite = $Sprite
onready var camera = $Camera2D

func _ready():
	pass	
	
func _physics_process(delta):
	
	movement = Vector2()
	
	xmoved = false
	ymoved = false

	if Input.is_action_pressed("down") and not Input.is_action_pressed("up"):
		movement.y += 1
		anim.play("walk")
		ymoved = true
	
	elif Input.is_action_pressed("up") and not Input.is_action_pressed("down"):
		movement.y -= 1
		anim.play("walk")
		ymoved = true
		
	if Input.is_action_pressed("right") and not Input.is_action_pressed("left"):
		movement.x += 1
		sprite.flip_h = false
		if not ymoved:
			anim.play("walk")
		xmoved = true 
	elif Input.is_action_pressed("left") and not Input.is_action_pressed("right"):
		movement.x -= 1
		sprite.flip_h = true
		if not ymoved:
			anim.play("walk")
		xmoved = true
	
	if Input.is_action_just_pressed("ui_cancel"):
		if camera.zoom.x == 0.25:
			camera.zoom = Vector2(7, 7)
		else:
			camera.zoom = Vector2(0.25, 0.25)
	
	if not xmoved and not ymoved:
		anim.play("idle")
	
	movement = move_and_slide(movement.normalized() * SPEED);
	
	
