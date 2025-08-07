using ImageView
using OccupancyGrids

simple_one = load_grid(SimpleIndoor1; inflation=2.0)
println("Willow Garage Grid Size: ", size(simple_one))

imshow(1.0 .- simple_one.data)