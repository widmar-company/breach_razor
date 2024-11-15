extends MeshInstance3D

# Declare variables for terrain settings
var terrain_size = Vector2(100, 100)  # Size of the terrain grid
var terrain_scale = 10.0  # Scaling factor for height
var noise_scale = 0.05  # Scale of the noise input
var noise_offset = Vector3.ZERO  # Offset for noise sampling

# Initialize FastNoiseLite
var noise = FastNoiseLite.new()

func _ready():
	# Set noise parameters
	noise.noise_type = FastNoiseLite.NoiseType.TYPE_SIMPLEX
	noise.frequency = noise_scale
	noise.seed = randi()  # Randomize the seed
	
	# Create terrain mesh
	var surface_tool = SurfaceTool.new()
	surface_tool.begin(Mesh.PRIMITIVE_TRIANGLES)
	generate_terrain(surface_tool)
	
	# Commit to mesh instance

func generate_terrain(surface_tool: SurfaceTool) -> void:
	# Generate vertices based on noise values
	for x in range(terrain_size.x):
		for z in range(terrain_size.y):
			var x_pos = float(x)
			var z_pos = float(z)
			
			# Sample noise to get height for the current vertex
			var noise_value = noise.get_noise_2d(x_pos + noise_offset.x, z_pos + noise_offset.z)
			var y_pos = noise_value * terrain_scale  # Scale the height

			# Add vertex to SurfaceTool
			surface_tool.add_vertex(Vector3(x_pos, y_pos, z_pos))

	# Connect vertices to form a grid of triangles
	for x in range(terrain_size.x - 1):
		for z in range(terrain_size.y - 1):
			var i = x * terrain_size.y + z  # Vertex index for the grid
			# Create two triangles for each quad on the grid
			surface_tool.add_index(i)
			surface_tool.add_index(i + 1)
			surface_tool.add_index(i + terrain_size.y)
			
			surface_tool.add_index(i + 1)
			surface_tool.add_index(i + terrain_size.y + 1)
			surface_tool.add_index(i + terrain_size.y)
	
	# Optionally, calculate normals and UVs if needed
	surface_tool.generate_normals()
	mesh = surface_tool.commit()
