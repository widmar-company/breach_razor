extends MeshInstance3D

func generate_terrain() -> void:
	
	var noise = FastNoiseLite.new()
	noise.noise_type = FastNoiseLite.TYPE_CELLULAR
	noise.frequency = 0.025
	noise.seed = OS.get_static_memory_usage()
	
	var verts = PackedVector3Array()

	
	var c = 0 

	# Build terrain to specification
	# This will be refactored later
	for x in Data.TERRAIN_SIZE:
		for z in Data.TERRAIN_SIZE:
			# Get noise data 
			var diff = 15
			var n1a = noise.get_noise_2d(x,-z) * diff
			var n1b = noise.get_noise_2d(x,-z-1) * diff
			var n1c = noise.get_noise_2d(x+1,-z-1) * diff
			
			var n2a = noise.get_noise_2d(x,-z) * diff
			var n2b = noise.get_noise_2d(x+1,-z-1) * diff
			var n2c = noise.get_noise_2d(x+1,-z) * diff
			
			# Generate our quad
			# Triangle 1
			verts.push_back(Vector3(x,   n1a, -z))
			verts.push_back(Vector3(x,   n1b, -z-1))
			verts.push_back(Vector3(x+1, n1c, -z-1))
			
			# Triangle 2 
			verts.push_back(Vector3(x,   n2a, -z))
			verts.push_back(Vector3(x+1, n2b, -z-1))
			verts.push_back(Vector3(x+1, n2c, -z))
			
			c += 1
	print("Placed ", c, " verts.")
		
	Data.terrain_verts = verts
		
# Apply a surface to our terrain.
func apply_terrain(verts: PackedVector3Array):
	var st = SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	
	for v in verts:
		st.set_uv(Vector2(v.x, v.z))
		st.add_vertex(v)
	
	st.generate_normals()
	st.generate_tangents()
	
	mesh = st.commit()
	var cs = CollisionShape3D.new()
	cs.shape = mesh.create_trimesh_shape()
	#cs.scale = 2
	$body.add_child(cs)
	#var cs = mesh.create_convex_shape()
	#if $CollisionShape3D.shape != null: 
		#print("Created collision shape: ", $CollisionShape3D.shape)

# Refactor this later
func build_quad() -> void:
	pass 
	
	
func debug_tri() -> void:
	var st = SurfaceTool.new()

	st.begin(Mesh.PRIMITIVE_TRIANGLES)

	# Prepare attributes for add_vertex.
	st.set_normal(Vector3(0, 0, 1))
	st.set_uv(Vector2(0, 0))
	# Call last for each vertex, adds the above attributes.
	st.add_vertex(Vector3(-1, -1, 0))

	st.set_normal(Vector3(0, 0, 1))
	st.set_uv(Vector2(0, 1))
	st.add_vertex(Vector3(-1, 1, 0))

	st.set_normal(Vector3(0, 0, 1))
	st.set_uv(Vector2(1, 1))
	st.add_vertex(Vector3(1, 1, 0))

	# Commit to a mesh.
	mesh = st.commit()
