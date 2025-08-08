module OccupancyGrids

# Defined in AbstractGrids
export OccupancyGrid, is_occupied

# Defined in DenseGrid
export DenseOccupancyGrid

# Defined in LoadGrid
export load_grid, GridInfo
export IncludedGrid, WillowGarage, SimpleIndoor, SimpleIndoor1, SimpleIndoor2

include("file_util/FileUtil.jl")
using .FileUtil

include("load_grid.jl")
using .LoadGrid

include("abstract_grids.jl")
using .AbstractGrids

include("dense_grid.jl")
using .DenseGrid



end # module OccupancyGrids
