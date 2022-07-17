extends Enemy

var roll: int = 1;

var attack_rates = {
	"1": 3.0,
	"2": 1.0,
	"3": 0.5,
	"4": 1.0, # Does not matter
	"5": 3.0,
	"6": 1.0 # Does not matter
}

var melee_factory = preload("res://Enemy_Elements/Boss_Abilities/BossAttack1.tscn");
var cone_factory = preload("res://Enemy_Elements/Boss_Abilities/BossAttack5.tscn");

onready var timer = $AttackTimer;
onready var ui = get_node("/root/MainScene/CanvasLayer/UI");

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
	pass;
	
func crossfire():
	pass
	
func toxic_spew():
	pass;
	
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
	pass;

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
			goo_explosion();
		_:
			attack_with_melee();
			print("If you get this message, there's a bug in Boss.gd");

func start_flicker_timer():
	$FlickerTimer.start();


func _on_UI_roll_results(_player, monster):
	print("signal received");
	roll = monster;
	timer.wait_time = attack_rates[str(roll)];


func _on_AttackTimer_timeout():
	attack();


func _on_FlickerTimer_timeout():
	modulate.a = 1.0;