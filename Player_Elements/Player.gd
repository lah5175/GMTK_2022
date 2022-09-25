extends KinematicBody2D
class_name Player


signal game_over;


# Basic parameters
var current_hp: int = 20;
var max_hp: int = 20;
var move_speed: int = 125;
var i_am_speed: int = 600;
var keys: int = 0;

# Attack variables
var attack_cooldown_time = 1000;
var next_attack_time = 0;
var attack_damage = 30;
var dash_damage: int = 5;
var colliders: Dictionary = {};

# Movement variables
var velocity = Vector2();
var face_direction = Vector2();

var roll: int = 1;

# Bools linked to timers
var is_invulnerable: bool = false;
var is_dashing: bool = false;
var can_place_bomb: bool = true;
var can_move: bool = true;
var can_shield: bool = true;
var is_shielding: bool = false;

# Preload weapons so we can instance them later
var arrow_factory = preload("res://Player_Elements/Weapon_Types/PlayerAttack2.tscn");
var bomb_factory = preload("res://Player_Elements/Weapon_Types/PlayerAttack3.tscn");
var orb_factory = preload("res://Player_Elements/Weapon_Types/PlayerAttack5.tscn");
var shield_factory = preload("res://Player_Elements/Weapon_Types/PlayerAttack6.tscn");

onready var healthNode = get_tree().get_root().get_node("SceneManager/MainScene/CanvasLayer/UI/Health")
onready var ui = get_node("/root/SceneManager/MainScene/CanvasLayer/UI");
onready var door : AnimatedSprite = get_node("/root/SceneManager/MainScene/BossDoor/AnimatedSprite");

onready var sprite = $AnimatedSprite;
onready var attackArea = $AttackArea;
onready var transition = get_node("/root/SceneManager/TransitionScreen");

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
	if can_move:
		move();
		
	if is_dashing:
		move_and_slide(face_direction * i_am_speed, Vector2.ZERO);
		
		for i in get_slide_count():
			var collision = get_slide_collision(i);
			var collider = collision.collider;
			if collider.get_class() == "Enemy" and !(collider in colliders):
				print("I collided with ", collider)
				colliders[collider] = true;
				collider.take_damage(dash_damage);
		
	# Attacking inputs
	if Input.is_action_just_pressed("attack"):
		attack();
	
	# Cancel the spin dash move
	if Input.is_action_just_released("attack") and !can_move:
		$SpinHoldTimer.stop();
		can_move = true;
		
	# Flash character if they are invulnerable
	if is_invulnerable and !is_dashing:
		modulate.a = 0.5 if Engine.get_frames_drawn() % 2 == 0 else 1.0;
		
	if keys >=3:
		door.animation = "open";

func move():
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
	if !is_invulnerable and !is_shielding:
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
	transition.transition("game_over");

	
# Attack functions
func swing_sword():
	$AttackArea/CollisionShape2D.disabled = false;
	$AttackTimer.start()
	var animation = getAttackAnimation();
	$AnimatedSprite.play(animation);
	
func shoot_arrow():
	var arrow = arrow_factory.instance();
	var parent = get_parent();
	parent.add_child(arrow);
	arrow.global_position = global_position;
	arrow.direction = face_direction;
	arrow.rotation = getCardinalRotation();
	$ArrowSFX.play();
	
func place_bomb():
	if can_place_bomb:
		can_move = false;
		var bomb = bomb_factory.instance();
		bomb.position = position;
		
		# We will need to tweak these values if the size of the player sprite changes
		if face_direction.x == 1:
			bomb.position.x += 15;
		elif face_direction.x == -1:
			bomb.position.x -= 15;
		elif face_direction.y == -1:
			bomb.position.y -= 17;
		elif face_direction.y == 1:
			bomb.position.y += 15;
			
		var parent = get_parent();
		parent.add_child(bomb);
		
		can_move = true;
		can_place_bomb = false;
		$BombTimer.start();
	
func charge_dash():
	can_move = false;
	colliders = {}; # Refresh collider list
	$SpinHoldTimer.start();
	
func spin_dash():
	var i_am_speed: int = 600;
	var dist: int = 100;
	is_dashing = true;
	is_invulnerable = true;
	$SpinDashTimer.start();
	
func shoot_orbs():
	var orbs: Array = [];
	var parent = get_parent();
	for i in range(3):
		var orb = orb_factory.instance();
		orb.position = position;
		
		if i == 1:
			orb.direction = face_direction.rotated(deg2rad(-45));
		elif i == 2:
			orb.direction = face_direction.rotated(deg2rad(45));
		else:
			orb.direction = face_direction;
		
		parent.add_child(orb);
		
func summon_shield():
	var shield = shield_factory.instance();
	add_child(shield);
	can_shield = false;
	is_shielding = true;
	$ShieldCooldownTimer.start();
	
func attack():
	match roll:
		1:
			swing_sword();
		2:
			shoot_arrow();
		3:
			place_bomb();
		4:
			charge_dash();
		5:
			shoot_orbs();
		6:
			if can_shield:
				summon_shield();
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
	
func _on_BombTimer_timeout():
	can_place_bomb = true;

func _on_SpinHoldTimer_timeout():
	spin_dash();

func _on_SpinDashTimer_timeout():
	is_dashing = false;
	is_invulnerable = false;
	can_move = true;
	
func _on_ShieldCooldownTimer_timeout():
	can_shield = true;


# Function overrides

func get_class(): return "Player";

