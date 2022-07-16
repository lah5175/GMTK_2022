extends KinematicBody2D
class_name Player


signal game_over;


# Basic parameters
var current_hp: int = 10;
var max_hp: int = 10;
var move_speed: int = 125;

# Attack variables
var attack_cooldown_time = 1000;
var next_attack_time = 0;
var attack_damage = 30;

# Movement variables
var velocity = Vector2();
var face_direction = Vector2();

var roll: int = 1;
var is_invulnerable: bool = false;

onready var healthNode = get_tree().get_root().get_node("MainScene/CanvasLayer/UI/Health")
onready var ui = get_node("/root/MainScene/CanvasLayer/UI");
onready var sprite = $AnimatedSprite;
onready var attackArea = $AttackArea;

# Preload weapons so we can instance them later
var arrow_factory = preload("res://Player_Elements/Weapon_Types/PlayerAttack2.tscn");

# Called when the node enters the scene tree for the first time.
func _ready():
	$AttackArea/CollisionShape2D.disabled = true;
	face_direction.y = 1; # To prevent frame 1 attack crash
	healthNode.update_hp(max_hp, current_hp)
	ui.connect("roll_results", self, "_on_UI_roll_results");

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
		attack();
		
	# Flash character if they are invulnerable
	if is_invulnerable:
		modulate.a = 0.5 if Engine.get_frames_drawn() % 2 == 0 else 1.0;
		
func getCardinalRotation():
	var cardinal_direction = {
		"up": PI,
		"down": 0,
		"left": PI/2,
		"right": -PI/2
	}
	
	if face_direction.x == 1:
		return cardinal_direction.right;
	elif face_direction.x == -1:
		return cardinal_direction.left;
	elif face_direction.y == -1:
		return cardinal_direction.up;
	elif face_direction.y == 1:
		return cardinal_direction.down;

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
	attackArea.rotation = getCardinalRotation();
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
	
# Attack functions
func swing_sword():
	$AttackArea/CollisionShape2D.disabled = false;
	$AttackTimer.start()
	var animation = getAttackAnimation();
	$AnimatedSprite.play(animation);
	
func shoot_arrow():
	var arrow = arrow_factory.instance();
	add_child(arrow);
	arrow.global_position = global_position;
	arrow.direction = face_direction;
	arrow.rotation = getCardinalRotation();
	$ArrowSFX.play();
	
func attack():
	match roll:
		1:
			swing_sword();
		2:
			shoot_arrow();
		3:
			swing_sword();
		4:
			swing_sword();
		5:
			swing_sword();
		6:
			swing_sword();
		_:
			swing_sword();
			print("If you get this message, there's a bug in Player.gd");
	
# Signal Functions
func _on_IFrames_timeout():
	is_invulnerable = false;
	modulate.a = 1.0;

func _on_AttackTimer_timeout():
	$AttackArea/CollisionShape2D.disabled = true;
	
func _on_UI_roll_results(player, monster):
	roll = player;
	
# Function overrides

func get_class(): return "Player";
