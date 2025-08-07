module OccupancyGrids

# Defined in AbstractGrids
export AbstractOccupancyGrid, is_occupied

# Defined in DenseGrid
export DenseOccupancyGrid

# Defined in LoadGrid
export load_grid, GridInfo
export IncludedGrid, WillowGarage, SimpleIndoor1

include("file_util/FileUtil.jl")
using .FileUtil

include("load_grid.jl")
using .LoadGrid

include("abstract_grids.jl")
using .AbstractGrids

include("dense_grid.jl")
using .DenseGrid



end # module OccupancyGrids
