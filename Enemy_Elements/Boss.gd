extends Enemy

signal bullet_start;

var roll: int = 1;

var is_exploding: bool = false;

var attack_rates = {
	"1": 3.0,
	"2": 1.0,
	"3": 10.00,
	"4": 5.0,
	"5": 3.0,
	"6": 10.00
}

var melee_factory = preload("res://Enemy_Elements/Boss_Abilities/BossAttack1.tscn");
var cone_factory = preload("res://Enemy_Elements/Boss_Abilities/BossAttack5.tscn");
var circle_factory = preload("res://Enemy_Elements/Ability_Types/PurpleAttack4.tscn");
var laser_factory = preload("res://Enemy_Elements/Boss_Abilities/BossAttack4.tscn");

onready var timer = $AttackTimer;
onready var ui = get_node("/root/SceneManager/MainScene/CanvasLayer/UI");
onready var switch = get_node("../BossSwitch");

# Called when the node enters the scene tree for the first time.
func _ready():
	set_params();
	ui.connect("roll_results", self, "_on_UI_roll_results");


func _physics_process(delta):
	var dist = position.distance_to(target.position);


func set_params():
	max_hp = 20;
	current_hp =  20;
	damage = 1;
	
# Attack functions
func attack_with_melee():
	var parent = get_parent();
	var melee = melee_factory.instance();
	parent.add_child(melee);
	
	melee.position.x = 1291;
	melee.position.y = -134;
	
func bombs_away():
	var parent = get_parent();
	var circle = circle_factory.instance();
	parent.add_child(circle);
	
	circle.position = target.position;
	
func crossfire():
	# See MainScene script
	emit_signal("bullet_start");
	
func toxic_spew():
	var parent = get_parent();
	var laser = laser_factory.instance();
	parent.add_child(laser);
	
	laser.position = position;
	laser.position.y += 120;
	laser.direction = (target.global_position - laser.global_position).normalized();
	laser.rotation = laser.direction.angle() + PI / 2;
	laser.target = target;
	
func throw_goo():
	var parent = get_parent();
	var cone1 = cone_factory.instance();
	var cone2 = cone_factory.instance();
	parent.add_child(cone1);
	parent.add_child(cone2);
	
	cone1.position = Vector2(1235, -57);
	cone2.position = Vector2(1337, -57);
	cone1.rotation = deg2rad(137.8);
	cone2.rotation = deg2rad(225.5);
	
	
func goo_explosion():
	print("boss is exploding");
	$ExplosionTimer.start();
	$AlertSFX.play();
	is_exploding = true;
	switch.enable_switch();

func attack():
	match roll:
		1:
			attack_with_melee();
		2:
			bombs_away();
		3:
			crossfire();
		4:
			toxic_spew();
		5:
			throw_goo();
		6:
			if !is_exploding:
				goo_explosion();
		_:
			attack_with_melee();
			print("If you get this message, there's a bug in Boss.gd");

func start_flicker_timer():
	$FlickerTimer.start();

func stop_explosion():
	print("you stopped the explosion")
	is_exploding = false;
	$ExplosionTimer.stop();
	$AlertSFX.stop();
	switch.disable_switch();

func _on_UI_roll_results(_player, monster):
	roll = monster;
	timer.wait_time = attack_rates[str(roll)];
	

func _on_AttackTimer_timeout():
	attack();
	is_exploding = false;


func _on_FlickerTimer_timeout():
	modulate.a = 1.0;


func _on_ExplosionTimer_timeout():
	print("explosion happens")
	$AlertSFX.stop();
	$ExplosionSFX.play();
	var player = get_node("../Player");
	player.take_damage(5);
	switch.disable_switch();
	# Sound
	# Screen flash
