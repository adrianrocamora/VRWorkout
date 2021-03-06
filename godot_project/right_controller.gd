extends ARVRController

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var last_pos = [Vector3(0,0,0),Vector3(0,0,0),Vector3(0,0,0)]
var last_time = [0,0,0]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func update_bone_orientations(orientations):
	get_node("hand_model").update_bone_orientations(orientations)

func is_fist():
	return get_node("hand_model").is_fist()

func set_beast_mode(enabled):
	if enabled:
		get_node("hand_model").beast_mode = true
	else:
		get_node("hand_model").beast_mode = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	last_pos[2] = last_pos[1]
	last_pos[1] = last_pos[0]
	last_pos[0] = self.translation
	last_time[2] = last_time[1] 
	last_time[1] = last_time[0]
	last_time[0] = delta 

func get_hit_velocity():
	var distance = self.translation.distance_to(last_pos[0])+ \
					last_pos[0].distance_to(last_pos[1])+ \
					last_pos[1].distance_to(last_pos[2])
		
	var timedelta = max(0.001, last_time[2])
	var velocity = distance/timedelta
	get_parent().get_parent().level.infolayer.print_info("Velocity %.2f"%velocity, "debug")
	return velocity


func do_rumble(good = true):
	if good:
		get_node("good_hit").show()
	else:
		get_node("bad_hit").show()
	self.set_rumble(0.5)
	get_node("RumbleTimer").start()
	
	
func _on_RumbleTimer_timeout():
	get_node("good_hit").hide()
	get_node("bad_hit").hide()
	self.set_rumble(0.0)
