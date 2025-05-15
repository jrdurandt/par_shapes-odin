package par_shapes

when ODIN_OS == .Linux {
	foreign import lib "x86_64-linux/libpar_shapes.a"
} else when ODIN_OS == .Windows {
	foreign import lib "x86_64-windows/par_shapes.lib"
} else when ODIN_OS == .Darwin {
	when ODIN_ARCH == .arm64 {
		foreign import lib "aarch64-macos/libpar_shapes.a"
	} else {
		foreign import lib "x86_64-macos/libpar_shapes.a"
	}
}

import c "core:c"

par_shape_mesh_s :: struct {
	points:     [^]c.float, // Flat list of 3-tuples (X Y Z X Y Z...)
	npoints:    c.int, // Number of points
	triangles:  [^]c.uint16_t, // Flat list of 3-tuples (I J K I J K...)
	ntriangles: c.int, // Number of triangles
	normals:    [^]c.float, // Optional list of 3-tuples (X Y Z X Y Z...)
	tcoords:    [^]c.float, // Optional list of 2-tuples (U V U V U V...)
}

@(default_calling_convention = "c", link_prefix = "par_shapes_")
foreign lib {
	free_mesh :: proc(mesh: ^par_shape_mesh_s) ---

	// Generators ------------------------------------------------------------------

	// Instance a cylinder that sits on the Z=0 plane using the given tessellation
	// levels across the UV domain.  Think of "slices" like a number of pizza
	// slices, and "stacks" like a number of stacked rings.  Height and radius are
	// both 1.0, but they can easily be changed with par_shapes_scale.
	create_cylinder :: proc(slices: c.int, stacks: c.int) -> ^par_shape_mesh_s ---

	// Cone is similar to cylinder but the radius diminishes to zero as Z increases.
	// Again, height and radius are 1.0, but can be changed with par_shapes_scale.
	create_cone :: proc(slices: c.int, stacks: c.int) -> ^par_shape_mesh_s ---

	// Create a disk of radius 1.0 with texture coordinates and normals by squashing
	// a cone flat on the Z=0 plane.
	create_parametric_disk :: proc(slices: c.int, stacks: c.int) -> ^par_shape_mesh_s ---

	// Create a donut that sits on the Z=0 plane with the specified inner radius.
	// The outer radius can be controlled with par_shapes_scale.
	create_torus :: proc(slices: c.int, stacks: c.int, radius: c.float) -> ^par_shape_mesh_s ---

	// Create a sphere with texture coordinates and small triangles near the poles.
	create_parametric_sphere :: proc(slices: c.int, stacks: c.int) -> ^par_shape_mesh_s ---

	// Approximate a sphere with a subdivided icosahedron, which produces a nice
	// distribution of triangles, but no texture coordinates.  Each subdivision
	// level scales the number of triangles by four, so use a very low number.
	create_subdivided_sphere :: proc(nsubdivisions: c.int) -> ^par_shape_mesh_s ---

	// More parametric surfaces.
	create_klein_bottle :: proc(slices: c.int, stacks: c.int) -> ^par_shape_mesh_s ---
	create_trefoil_knot :: proc(slices: c.int, stacks: c.int) -> ^par_shape_mesh_s ---
	create_hemisphere :: proc(slices: c.int, stacks: c.int) -> ^par_shape_mesh_s ---
	create_plane :: proc(slices: c.int, stacks: c.int) -> ^par_shape_mesh_s ---

	// Generate points for a 20-sided polyhedron that fits in the unit sphere.
	// Texture coordinates and normals are not generated.
	create_icosahedron :: proc() -> ^par_shape_mesh_s ---

	// Generate points for a 12-sided polyhedron that fits in the unit sphere.
	// Again, texture coordinates and normals are not generated.
	create_dodecahedron :: proc() -> ^par_shape_mesh_s ---

	// More platonic solids.
	create_octahedron :: proc() -> ^par_shape_mesh_s ---
	create_tetrahedron :: proc() -> ^par_shape_mesh_s ---
	create_cube :: proc() -> ^par_shape_mesh_s ---

	// Generate an orientable disk shape in 3-space.  Does not include normals or
	// texture coordinates.
	create_disk :: proc(radius: c.float, slices: c.int, center: [^]c.float, normal: [^]c.float) -> ^par_shape_mesh_s ---

	// Create an empty shape.  Useful for building scenes with merge_and_free.
	create_empty :: proc() -> ^par_shape_mesh_s ---

	// Generate a rock shape that sits on the Y=0 plane, and sinks into it a bit.
	// This includes smooth normals but no texture coordinates.  Each subdivision
	// level scales the number of triangles by four, so use a very low number.
	create_rock :: proc(seed: c.int, nsubdivisions: c.int) -> ^par_shape_mesh_s ---

	// Create trees or vegetation by executing a recursive turtle graphics program.
	// The program is a list of command-argument pairs.  See the unit test for
	// an example.  Texture coordinates and normals are not generated.
	create_lsystem :: proc(program: cstring, slices: c.int, maxdepth: c.int) -> ^par_shape_mesh_s ---

	// Queries ---------------------------------------------------------------------

	// Dump out a text file conforming to the venerable OBJ format.
	export :: proc(mesh: ^par_shape_mesh_s, objfile: ^cstring) ---

	// Take a pointer to 6 floats and set them to min xyz, max xyz.
	compute_aabb :: proc(mesh: ^par_shape_mesh_s, aabb: [^]c.float) ---

	// Make a deep copy of a mesh.  To make a brand new copy, pass null to "target".
	// To avoid memory churn, pass an existing mesh to "target".
	clone :: proc(mesh: ^par_shape_mesh_s, target: ^par_shape_mesh_s) ---

	// Transformations -------------------------------------------------------------

	merge :: proc(dst: ^par_shape_mesh_s, src: ^par_shape_mesh_s) ---
	translate :: proc(mesh: ^par_shape_mesh_s, x, y, z: c.float) ---
	rotate :: proc(mesh: ^par_shape_mesh_s, radians: c.float, axis: [^]c.float) ---
	scale :: proc(mesh: ^par_shape_mesh_s, x, y, z: c.float) ---
	merge_and_free :: proc(dst: ^par_shape_mesh_s, src: ^par_shape_mesh_s) ---

	// Reverse the winding of a run of faces.  Useful when drawing the inside of
	// a Cornell Box.  Pass 0 for nfaces to reverse every face in the mesh.
	invert :: proc(mesh: ^par_shape_mesh_s, startface: c.int, nfaces: c.int) ---

	// Remove all triangles whose area is less than minarea.
	remove_degenerate :: proc(mesh: ^par_shape_mesh_s, minarea: c.float) ---

	// Dereference the entire index buffer and replace the point list.
	// This creates an inefficient structure, but is useful for drawing facets.
	// If create_indices is true, a trivial "0 1 2 3..." index buffer is generated.
	unweld :: proc(mesh: ^par_shape_mesh_s, create_indices: c.bool) ---

	// Merge colocated verts, build a new index buffer, and return the
	// optimized mesh.  Epsilon is the maximum distance to consider when
	// welding vertices. The mapping argument can be null, or a pointer to
	// npoints integers, which gets filled with the mapping from old vertex
	// indices to new indices.
	weld :: proc(mesh: ^par_shape_mesh_s, epsilon: c.float, mapping: ^c.uint16_t) -> ^par_shape_mesh_s ---

	// Compute smooth normals by averaging adjacent facet normals.
	compute_normals :: proc(m: ^par_shape_mesh_s) ---

	// Global Config ---------------------------------------------------------------

	set_epsilon_welded_normals :: proc(epsilon: c.float) ---
	set_epsilon_degenerate_normals :: proc(epsilon: c.float) ---


	// Advanced --------------------------------------------------------------------

	_compute_welded_normals :: proc(m: ^par_shape_mesh_s) ---
	_connect :: proc(scene: ^par_shape_mesh_s, cylinder: ^par_shape_mesh_s, slices: c.int) ---
}
