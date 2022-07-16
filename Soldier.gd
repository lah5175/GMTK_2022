extends Enemy

var is_ready_for_rolls: bool = false;

var projectile_speed: int = 300;
var roll: int = 1;

# Preload assets for attacks
var rat_projectile = preload("res://RatProjectile.tscn");

onready var timer = $AttackTimer;
onready var ui = get_node("/root/MainScene/CanvasLayer/UI");

# Called when the node enters the scene tree for the first time.
func _ready():
	set_params();
	ui.connect("roll_results", self, "_on_UI_roll_results");


func set_params():
	max_hp = 5;
	current_hp = 5;
	move_speed = 100;
	damage = 1;
	attack_rate = 1.0;
		
	timer.wait_time = attack_rate;
	timer.start();	

# Please rename this function once we have more attacks in the game
func spawn_projectile():
	# Create a RatProjectile node and attach it to the main scene
	var proj = rat_projectile.instance();
	get_node("/root/MainScene").add_child(proj);
	
	# Set the initial position, direction, and rotation
	# I don't really know, this is some black magic stuff
	proj.position = position;
	var dir = (target.global_position - proj.global_position).normalized();
	proj.global_rotation = dir.angle() + PI / 2.0;
	proj.direction = dir;
	
func attack():
	match roll:
		1:
			spawn_projectile();
		2:
			pass;
		3:
			pass;
		4:
			pass;
		5:
			pass;
		6:
			pass;
		_:
			spawn_projectile();
			print("If you get this message, there's a bug in Soldier.gd");
			

func start_flicker_timer():
	$FlickerTimer.start();


func _on_AttackTimer_timeout():
	if is_ready_for_rolls:
		attack();

func _on_UI_roll_results(_player, monster):
	print("signal received");
	roll = monster;
	is_ready_for_rolls = true;


func _on_FlickerTimer_timeout():
	modulate.a = 1.0;
