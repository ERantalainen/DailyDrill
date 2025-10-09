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

func check_score() -> int:
# Calculate which section the wheel stopped on
	var normalized_angle = fmod(current_angle, TAU)
	var section_index = int(normalized_angle / (TAU / num_sections))
	if section_index == target_color:
		return 10
	else:
		var temp_score = abs(target_color - section_index)
		return 10 - 3 * min(temp_score, num_sections - temp_score)

func _ready() -> void:
	target_color = randi() % num_sections
	generate_wheel()
	start_spin()
