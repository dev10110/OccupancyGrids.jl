module DenseGrid

export DenseOccupancyGrid

using StaticArrays
using ..AbstractGrids
using ..LoadGrid

struct DenseOccupancyGrid{T<:Real,M,N} <: AbstractOccupancyGrid
    data::SMatrix{M,N,T}
    grid_resolution::Float64  # meters per cell
    inv_resolution::Float64   # 1/grid_resolution for efficiency

    # occupied_threshold::Float64 = 0.65
    # free_threshold::Float64 = 0.35

    function DenseOccupancyGrid{T,M,N}(data::SMatrix{M,N,T}, resolution::Float64) where {T<:Real,M,N}
        new{T,M,N}(data, resolution, 1.0 / resolution)
    end
end

# Convenient outer constructors
DenseOccupancyGrid(data::SMatrix{M,N,T}, resolution::Float64) where {T<:Real,M,N} = DenseOccupancyGrid{T,M,N}(data, resolution)

function AbstractGrids.is_occupied(grid::DenseOccupancyGrid, x::Real, y::Real)
    # Convert coordinates to indices (1-based) using pre-computed inverse
    i = Int(floor(x * grid.inv_resolution)) + 1
    j = Int(floor(y * grid.inv_resolution)) + 1

    # Bounds check with early return for out-of-bounds
    if i < 1 || i > size(grid.data, 1) || j < 1 || j > size(grid.data, 2)
        throw(BoundsError(grid, (i, j)))
    end

    return grid.data[i, j]
end

function Base.size(grid::DenseOccupancyGrid)::Tuple{Float64,Float64}
    rows, cols = size(grid.data)
    return (rows * grid.grid_resolution, cols * grid.grid_resolution)
end

# TODO might need to include more information from the info object?
function LoadGrid.load_grid(info::GridInfo, data::SMatrix{M,N,T})::DenseOccupancyGrid{T,M,N} where {M,N,T<:Real}
    return DenseOccupancyGrid(data, info.resolution)
end


end # module DenseGrid