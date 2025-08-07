using OccupancyGrids

willow_garage_grid = load_grid(WillowGarage)
println("Willow Garage Grid Size: ", size(willow_garage_grid))

simple_one = load_grid(SimpleIndoor1)
println("Simple Indoor 1 Grid Size: ", size(simple_one))