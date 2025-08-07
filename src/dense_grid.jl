"""
    DenseGrid

This module implements a dense occupancy grid, where the grid is represented by a
dense matrix. This is a straightforward implementation of the `OccupancyGrid`
interface.
"""
module DenseGrid

export DenseOccupancyGrid

using DSP
using ..AbstractGrids
using ..LoadGrid

"""
    DenseOccupancyGrid{T<:Real} <: OccupancyGrid

A concrete implementation of an occupancy grid using a dense matrix.

# Fields
- `data::Matrix{T}`: The matrix holding the occupancy values. The type `T` is typically a subtype of `Real` (e.g., `Float64`).
- `grid_resolution::Float64`: The resolution of the grid in meters per cell.
- `inv_resolution::Float64`: The inverse of the resolution, pre-calculated for efficiency in coordinate transformations.
- `occupied_threshold::Float64`: The threshold above which a cell is considered occupied.
- `free_threshold::Float64`: The threshold below which a cell is considered free.

# Keyword Arguments
- `inflation::Float64`: The inflation radius in meters. Obstacles will be inflated by this amount. Defaults to `0.0`.
- `negate::Bool`: If `true`, the input `data` is negated (i.e., `1.0 - data`). This is useful when the input data has `1` for free and `0` for occupied. Defaults to `false`.
"""
struct DenseOccupancyGrid{T<:Real} <: OccupancyGrid
    data::Matrix{T}
    grid_resolution::Float64  # meters per cell
    inv_resolution::Float64   # 1/grid_resolution for efficiency
    occupied_threshold::Float64
    free_threshold::Float64

    function DenseOccupancyGrid{T}(data::Matrix{T}, resolution::Float64, occupied_threshold::Float64, free_threshold::Float64; inflation::Float64=0.0, negate::Bool=false) where {T<:Real}
        # This is weird -- 0 is free, 1 is occupied. But 1 is white, 0 is black.
        if !negate
            data .= 1.0 .- data
        end

        if inflation != 0.0
            @show "inflating"
            inflate_obstacles!(data, ceil(Int, inflation / resolution))
        end

        new{T}(data, resolution, 1.0 / resolution, occupied_threshold, free_threshold)
    end
end

function inflate_obstacles!(data::Matrix{T}, inflation_cells::Int) where {T<:Real}
    @show inflation_cells
    kernel = ones(inflation_cells, inflation_cells)
    new_data = conv(data, kernel)
    # Trim new data matrix to the original size, taking from the center

    rows, cols = size(data)
    start_row = ceil(Int, inflation_cells / 2)
    start_col = ceil(Int, inflation_cells / 2)
    end_row = start_row + rows - 1
    end_col = start_col + cols - 1

    data .= clamp.(new_data[start_row:end_row, start_col:end_col], 0.0, 1.0)
end

# Convenient outer constructors
DenseOccupancyGrid(data::Matrix{T}, resolution::Float64, occupied_threshold::Float64, free_threshold::Float64; kwargs...) where {T<:Real} = DenseOccupancyGrid{T}(data, resolution, occupied_threshold, free_threshold; kwargs...)

# Constructor with default thresholds for backwards compatibility
DenseOccupancyGrid(data::Matrix{T}, resolution::Float64; kwargs...) where {T<:Real} = DenseOccupancyGrid{T}(data, resolution, 0.65, 0.35; kwargs...)

"""
    is_occupied(grid::DenseOccupancyGrid, x::Real, y::Real) -> Bool

Checks if the specified world coordinates are occupied in the dense grid.

Converts the world coordinates (x, y) into matrix indices and checks the corresponding
cell's value against the free_threshold. Returns true if the cell value is greater
than the free_threshold.

# Throws
- `BoundsError` if the coordinates `(x, y)` are outside the grid's boundaries.
"""
function AbstractGrids.is_occupied(grid::DenseOccupancyGrid, x::Real, y::Real)
    # Convert coordinates to indices (1-based) using pre-computed inverse
    i = Int(floor(x * grid.inv_resolution)) + 1
    j = Int(floor(y * grid.inv_resolution)) + 1

    # Bounds check with early return for out-of-bounds
    if i < 1 || i > size(grid.data, 1) || j < 1 || j > size(grid.data, 2)
        throw(BoundsError(grid, (i, j)))
    end

    return grid.data[i, j] > grid.free_threshold
end

"""
    Base.size(grid::DenseOccupancyGrid) -> Tuple{Float64, Float64}

Returns the physical dimensions of the grid in world coordinates (meters).

Calculates the total width and height of the grid by multiplying the number of rows
and columns in the data matrix by the grid resolution.
"""
function Base.size(grid::DenseOccupancyGrid)::Tuple{Float64,Float64}
    rows, cols = size(grid.data)
    return (rows * grid.grid_resolution, cols * grid.grid_resolution)
end

"""
    load_grid(info::GridInfo, data::Matrix{T}) where {T<:Real} -> DenseOccupancyGrid{T}

A factory method to construct a `DenseOccupancyGrid` from a `GridInfo` object and
a data matrix.

This function is part of the `LoadGrid` interface and allows for the creation of a
`DenseOccupancyGrid` when loading a grid from a file. Uses the thresholds specified
in the GridInfo object.
"""
function LoadGrid.load_grid(info::GridInfo, data::Matrix{T}; kwargs...)::DenseOccupancyGrid{T} where {T<:Real}
    return DenseOccupancyGrid(data, info.resolution, info.occuped_threshold, info.free_threshold; kwargs...)
end


end # module DenseGrid
