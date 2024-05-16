# par_shapes bindings for Odin

> WIP: Basic shape generation works, need to test more advances functions. See [TODO](##TODO)

[par_shapes](https://prideout.net/shapes) bindings for [Odin](https://odin-lang.org/)

## Build (Linux):
`cd src`   
`make`


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

## TODO:
- [ ] Windows and Mac builds
- [ ] Tests
- [ ] Fix mapping of types
