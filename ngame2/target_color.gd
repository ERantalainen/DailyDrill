extends MeshInstance2D

func generate_target(target_color):
	var box_size = Vector2(100, 100)
	var surface_tool = SurfaceTool.new()
	surface_tool.begin(Mesh.PRIMITIVE_TRIANGLES)

	var vertices = [
		Vector3(0, 0, 0),                     
		Vector3(box_size.x, 0, 0),          
		Vector3(0, box_size.y, 0),           
		Vector3(box_size.x, box_size.y, 0)   
	]

	surface_tool.set_color(target_color)
	surface_tool.add_vertex(vertices[0])
	surface_tool.add_vertex(vertices[1])
	surface_tool.add_vertex(vertices[2])

	surface_tool.set_color(target_color)
	surface_tool.add_vertex(vertices[1])
	surface_tool.add_vertex(vertices[3])
	surface_tool.add_vertex(vertices[2])

	# Commit the mesh
	var mesh = surface_tool.commit()
	self.mesh = mesh
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
