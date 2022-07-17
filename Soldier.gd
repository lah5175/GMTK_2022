extends Enemy


var projectile_speed: int = 300;
var roll: int = 1;

var is_casting: bool = false;
var is_slime_spawned = false;

var attack_rates = {
	"1": 1.0,
	"2": 1.0,
	"3": 2.0,
	"4": 3.0,
	"5": 2.0,
	"6": 1.0
}

var attack_distances = {
	"1": 20,
	"2": chase_dist - 10,
	"3": chase_dist - 10,
	"4": 30,
	"5": 50,
	"6": chase_dist
}

# Preload assets for attacks
var rat_projectile = preload("res://RatProjectile.tscn");
var cone_factory = preload("res://Enemy_Elements/Ability_Types/PurpleAttack5.tscn");

onready var timer = $AttackTimer;
onready var ui = get_node("/root/MainScene/CanvasLayer/UI");

# Called when the node enters the scene tree for the first time.
func _ready():
	set_params();
	ui.connect("roll_results", self, "_on_UI_roll_results");
	
func _physics_process(delta):
	if !is_casting:
		var dist = position.distance_to(target.position);
		if dist < chase_dist and dist > attack_dist:
			var vel = (target.position - position).normalized();
			move_and_slide(vel * move_speed);

func set_params():
	max_hp = 5;
	current_hp = 5;
	move_speed = 40;
	damage = 1;
	attack_dist = 20;
	attack_rate = 1.0;
	
func stop_casting():
	is_casting = false;

# Attack functions
func attack_with_melee():
	timer.wait_time = attack_rate;
	target.take_damage(damage);

# Should probably be its own scene eventually
func shoot_orb():
	timer.wait_time = attack_rate;
	
	# Create a RatProjectile node and attach it to the main scene
	var proj = rat_projectile.instance();
	get_parent().add_child(proj);
	
	# Set the initial position, direction, and rotation
	# I don't really know, this is some black magic stuff
	proj.position = position;
	var dir = (target.global_position - proj.global_position).normalized();
	proj.global_rotation = dir.angle() + PI / 2.0;
	proj.direction = dir;
	
func shoot_homing_orbs():
	pass;

func burst_circle():
	pass;
	
func spray_cone():
	is_casting = true;
	attack_dist = 50;
	timer.wait_time = attack_rate;
	var cone = cone_factory.instance();
	var parent = get_parent();
	parent.add_child(cone);
	
	cone.position = position;
	cone.direction = (target.global_position - cone.global_position).normalized();
	cone.position.x += cone.direction.x * 20;
	cone.position.y += cone.direction.y * 20;
	cone.rotation = cone.direction.angle() + PI / 2;
	cone.parent = self;
	
func split():
	# Make sure spawned ones don't immediatly split
	is_casting = true;
	var parent = get_parent();
	var slime = load("res://Soldier.tscn").instance();
	slime.position = position;
	position.x += 20;
	parent.add_child(slime);
	is_slime_spawned = true;
	is_casting = false;
	
	
func attack():
	shoot_orb();
#	match roll:
#		1:
#			attack_with_melee();
#		2:
#			shoot_orb();
#		3:
#			shoot_homing_orbs();
#		4:
#			burst_circle();
#		5:
#			spray_cone();
#		6:
#			if !is_slime_spawned:
#				split();
#		_:
#			attack_with_melee();
#			print("If you get this message, there's a bug in Soldier.gd");
			

func start_flicker_timer():
	$FlickerTimer.start();


func _on_AttackTimer_timeout():
	if position.distance_to(target.position) <= attack_dist:
		attack();

func _on_UI_roll_results(_player, monster):
	print("signal received");
	roll = monster;
	is_slime_spawned = false;
	attack_rate = attack_rates[str(roll)];
	attack_dist = attack_distances[str(roll)];


func _on_FlickerTimer_timeout():
	modulate.a = 1.0;
