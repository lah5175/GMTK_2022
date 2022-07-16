extends KinematicBody2D


var current_hp: int = 10;
var max_hp: int = 10;
var move_speed: int = 125;

# Attack variables
var is_attacking : bool = false;
var attack_cooldown_time = 1000;
var next_attack_time = 0;
var attack_damage = 30;

var velocity = Vector2();
var face_direction = Vector2();

onready var sprite = $AnimatedSprite;


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _physics_process (delta):
	velocity = Vector2();
#	if not is_attacking:
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1;
		face_direction = Vector2(0, -1);
	if Input.is_action_pressed("move_down"):
		velocity.y += 1;
		face_direction = Vector2(0, 1);
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1;
		face_direction = Vector2(-1, 0);
	if Input.is_action_pressed("move_right"):
		velocity.x += 1;
		face_direction = Vector2(1, 0);

	velocity = velocity.normalized();
	move_and_slide(velocity * move_speed, Vector2.ZERO);
	manage_animations();
		
	if Input.is_action_just_pressed("attack"):
		is_attacking = true;
		var animation = getAttackAnimation();
		$AnimatedSprite.play(animation);
	if Input.is_action_just_released("attack"):
		is_attacking = false;


func manage_animations ():
	if velocity.x > 0:
		play_animation("MoveRight");
	elif velocity.x < 0:
		play_animation("MoveLeft");
	elif velocity.y < 0:
		play_animation("MoveUp");
	elif velocity.y > 0:
		play_animation("MoveDown");
	elif face_direction.x == 1:
		play_animation("IdleRight");
	elif face_direction.x == -1:
		play_animation("IdleLeft");
	elif face_direction.y == -1:
		play_animation("IdleUp");
	elif face_direction.y == 1:
		play_animation("IdleDown");

func getAttackAnimation():
	if face_direction.x == 1:
		return "AttackRight";
	elif face_direction.x == -1:
		 return "AttackLeft";
	elif face_direction.y == -1:
		return "AttackUp";
	elif face_direction.y == 1:
		return "AttackDown";
		
func play_animation (sprite_name):
	if sprite.animation != sprite_name:
		sprite.play(sprite_name);

func _input(event):
	if event.is_action_pressed("attack"):
		is_attacking = true;
		var animation = getAttackAnimation();
		$AnimatedSprite.play(animation);
