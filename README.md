# par_shapes bindings for Odin

[par_shapes](https://prideout.net/shapes) bindings for [Odin](https://odin-lang.org/)

> par_shapes used under MIT License

## Build:

### Linux:

Makefile
```
cd src
make
```

Zig
```
zig build -Dtarget=x86_64-linux
```

### Windows:

Batch
```
cd src
./build.bat
```

Zig
```
zig build -Dtarget=x86_64-windows
```

### MacOS (Darwin):

Make
```
cd src
make
```

Zig
```
zig build -Dtarget=x86_64-macos
zig build -Dtarget=arm64-macos
```

## Example:
```
import ps "par_shapes"
...
// Create a parametric sphere with 16 slices and 16 stacks
sphere_shape := ps.create_parametric_sphere(16, 16)

// Defer freeing the shape mesh
defer ps.free_mesh(sphere_shape)

// par_shapes returns pointers to the data. Use slices to get the data as fixed arrays

sphere_pos := sphere_shape.points[0:sphere_shape.npoints * 3]
sphere_texcoords := sphere_shape.tcoords[0:sphere_shape.npoints * 2]
sphere_normals := sphere_shape.normals[0:sphere_shape.npoints * 3]

sphere_triangles := sphere_shape.triangles[0:sphere_shape.ntriangles * 3]

```
