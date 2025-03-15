package samples

import par ".."
import "core:fmt"
import "core:math"
import "core:strings"
import rl "vendor:raylib"

create_shape_model :: proc(shape: ^par.par_shape_mesh_s) -> (model: rl.Model) {
	mesh: rl.Mesh
	mesh.vertexCount = shape.npoints
	mesh.triangleCount = shape.ntriangles

	mesh.vertices = shape.points
	mesh.texcoords = shape.tcoords
	mesh.normals = shape.normals
	mesh.indices = shape.triangles
	rl.UploadMesh(&mesh, false)
	par.free_mesh(shape)

	return rl.LoadModelFromMesh(mesh)
}

main :: proc() {
	rl.InitWindow(800, 600, "Shapes")
	defer rl.CloseWindow()
	rl.SetTargetFPS(60)

	camera := rl.Camera3D {
		position   = {0, 5, 5},
		target     = {0, 0, 0},
		up         = {0, 1, 0},
		fovy       = 45,
		projection = .PERSPECTIVE,
	}

	sphere_model := create_shape_model(par.create_parametric_sphere(8, 8))

	cube_model := create_shape_model(par.create_cube())

	cone_shape := par.create_cone(8, 8)
	axis: [3]f32 = {1, 0, 0}
	par.rotate(cone_shape, -(math.PI / 2), &axis[0])
	par.scale(cone_shape, 1, 2, 1)
	cone_model := create_shape_model(cone_shape)

	knot_model := create_shape_model(par.create_trefoil_knot(8, 32))

	torus_shape := par.create_torus(8, 8, 0.5)
	par.rotate(torus_shape, -(math.PI / 2), &axis[0])
	torus_mode := create_shape_model(torus_shape)

	for !rl.WindowShouldClose() {
		rl.UpdateCamera(&camera, .ORBITAL)
		rl.BeginDrawing()
		defer rl.EndDrawing()

		rl.ClearBackground(rl.BLACK)
		rl.BeginMode3D(camera)
		{
			rl.DrawModelWires(sphere_model, {0, 1, 0}, 1, rl.RED)
			rl.DrawModelWires(cube_model, {1.5, 0, -1}, 1.5, rl.GREEN)
			rl.DrawModelWires(cone_model, {-2, 0, 0}, 1, rl.BLUE)
			rl.DrawModelWires(knot_model, {0, 1, -2}, 1, rl.YELLOW)
			rl.DrawModelWires(torus_mode, {0, 0.5, 3}, 1, rl.PINK)
			rl.DrawGrid(10, 1)
		}
		rl.EndMode3D()
		rl.DrawFPS(0, 0)
	}
}
