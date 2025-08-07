using OccupancyGrids

willow_garage_grid = load_grid(WillowGarage)

println("Willow Garage Grid Size: ", size(willow_garage_grid))