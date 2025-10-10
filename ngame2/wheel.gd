extends MeshInstance2D
signal end_score(score :int)
var num_sections = 8
var radius = 280
var is_spinning = false
var is_stopping = false
var spin_speed = 0.0
var deceleration = 0.2
var current_angle = 0.0
var section_colors = []
var target_color

func generate_colors():
	for i in range(num_sections):
		var hue = float(i) / num_sections
		section_colors.append(Color.from_hsv(hue, 1.0, 1.0))
	
func generate_wheel():
	var surface_tool = SurfaceTool.new()
	surface_tool.begin(Mesh.PRIMITIVE_TRIANGLES)
	generate_colors()
	var center = Vector3.ZERO
	var rad_step = 2 * PI / num_sections
	for i in range(num_sections):
		var start_angle = i * rad_step
		var end_angle = (i + 1) * rad_step
		surface_tool.set_color(section_colors[i])
		surface_tool.add_vertex(center)
		surface_tool.add_vertex(Vector3(cos(start_angle), sin(start_angle), 0) * radius)
		surface_tool.add_vertex(Vector3(cos(end_angle), sin(end_angle), 0) * radius)
		var mesh_data = surface_tool.commit_to_arrays()
		var mesh = ArrayMesh.new()
		mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, mesh_data)
		self.mesh = mesh
	var viewport_size = get_viewport_rect().size
	self.position = viewport_size / 2

func _process(delta):
	if is_spinning:
		current_angle += spin_speed
		if is_stopping:
			spin_speed *= deceleration
		rotation = current_angle
	if spin_speed < 0.01:
		is_spinning = false
	if (!is_spinning && is_stopping):
		emit_signal("end_score", check_score())
		

func start_spin():
	if is_spinning:
		return
	is_spinning = true
	spin_speed = 0.1

func	 remap_index(index:int) ->int:
	match index:
		0: return 5
		1: return 4
		2: return 3
		3: return 2
		4: return 1
		5: return 0
		6: return 7
		7: return 6
	return index
	

func check_score() -> int:
	#Godot 0 angle is at three o'clock, so adjusting by -pi/2 moves check to the top
	var normalized_angle = fmod(current_angle - PI / 2, TAU)
#	draw_line(Vector2.ZERO, Vector2(cos(normalized_angle), sin(normalized_angle)) * radius * 1.2, Color.YELLOW, 2.0)
	var section_index = remap_index((int(normalized_angle / (TAU / num_sections)) + 2) %num_sections)
#	var string = "Hit index "+str(section_index)+", target was "+str(target_color)
#	print(string)
	if section_index == target_color:
		return 10
	else:
		var temp_score = abs(target_color - section_index)
		return 10 - 3 * min(temp_score, num_sections - temp_score)

func _ready() -> void:
	generate_wheel()
	#for i in range(num_sections):
		#var start_angle = i * TAU / num_sections
		#var end_angle = (i + 1) * TAU / num_sections
		#print("Section ", i, ": ", start_angle, " to ", end_angle)

#func _draw():
	#var normalized_angle = fmod(current_angle - PI/2, TAU)
	#var debug_length = radius * 1.2
	#draw_line(Vector2.ZERO, Vector2(cos(normalized_angle), sin(normalized_angle)) * debug_length, Color.WHITE, 2.0)
	#for i in range(num_sections):
		#var angle = (i + 2) * TAU / num_sections - PI/2  # Align with the top
		#var color = section_colors[i]
		#draw_circle(Vector2(cos(angle), sin(angle)) * radius * 0.7, 10, color)  # Draw a small circle for each color
