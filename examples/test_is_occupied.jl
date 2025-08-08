using OccupancyGrids

simple_one = load_grid(SimpleIndoor2; inflation=0.1)

occupied = is_occupied(simple_one, (1.0, 2.0))

for i in 0.0:0.5:(size(simple_one)[1]-0.01)
    for j in 0.0:0.5:(size(simple_one)[2]-0.01)
        print(is_occupied(simple_one, (j, (size(simple_one)[2] - 0.01 - i))))
    end
    println("")
end
