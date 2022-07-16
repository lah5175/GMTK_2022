extends KinematicBody2D
class_name Player


signal game_over;


# Basic parameters
var current_hp: int = 10;
var max_hp: int = 10;
var move_speed: int = 125;

# Attack variables
var is_attacking : bool = false;
var attack_cooldown_time = 1000;
var next_attack_time = 0;
var attack_damage = 30;

# Movement variables
var velocity = Vector2();
var face_direction = Vector2();

var is_invulnerable: bool = false;
onready var healthNode = get_tree().get_root().get_node("MainScene/CanvasLayer/UI/Health")
onready var sprite = $AnimatedSprite;
onready var attackArea = $AttackArea;

# Called when the node enters the scene tree for the first time.
func _ready():
	$AttackArea/CollisionShape2D.disabled = true;
	face_direction.y = 1; # To prevent frame 1 attack crash
	healthNode.update_hp(max_hp, current_hp)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _physics_process (delta):		
	velocity = Vector2();
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
		
	# Attacking inputs
	if Input.is_action_just_pressed("attack"):
		is_attacking = true;
		$AttackArea/CollisionShape2D.disabled = false;
		$AttackTimer.start()
		var animation = getAttackAnimation();
		$AnimatedSprite.play(animation);
	if Input.is_action_just_released("attack"):
		is_attacking = false;
		
	# Flash character if they are invulnerable
	if is_invulnerable:
		modulate.a = 0.5 if Engine.get_frames_drawn() % 2 == 0 else 1.0;
		

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
		attackArea.rotation = -PI/2;
		return "AttackRight";
	elif face_direction.x == -1:
		attackArea.rotation = PI/2;
		return "AttackLeft";
	elif face_direction.y == -1:
		attackArea.rotation = PI;
		return "AttackUp";
	elif face_direction.y == 1:
		attackArea.rotation = 0;
		return "AttackDown";
		
func play_animation (sprite_name):
	if sprite.animation != sprite_name:
		sprite.play(sprite_name);
		
func take_damage(damage):
	if !is_invulnerable:
		is_invulnerable = true;
		current_hp -= damage;
		healthNode.update_hp(current_hp, max_hp);
		if current_hp <= 0:
			die();
		else:
			$IFrames.start();
			$DamagedSFX.play();
			# This implementation will cause a problem if the same Area2D
			# needs to hit multiple times

func die():
	hide();
	$DeathSFX.play();
	print("I'M DEAD")
	emit_signal("game_over"); # TODO: Connect this signal

func _on_IFrames_timeout():
	is_invulnerable = false;
	modulate.a = 1.0;

func _on_AttackTimer_timeout():
	$AttackArea/CollisionShape2D.disabled = true;
	
# Function overrides

func get_class(): return "Player";
