"""
    AbstractGrids

This module defines the abstract interface for occupancy grids. Any concrete implementation
of an occupancy grid should subtype `OccupancyGrid` and implement the required
functions.
"""
module AbstractGrids

export OccupancyGrid, is_occupied, sdf

"""
    OccupancyGrid

The abstract supertype for all occupancy grid implementations.

This type defines the common interface for working with occupancy grids, such as querying
whether a specific location is occupied and getting the physical dimensions of the grid.
"""
abstract type OccupancyGrid end

# Main method that concrete types should implement
"""
    is_occupied(grid::OccupancyGrid, x::Real, y::Real) -> Bool

Determine if the location (x, y) in world coordinates is considered occupied.

This function must be implemented by concrete subtypes of `OccupancyGrid`.

# Arguments
- `grid`: The occupancy grid object.
- `x`: The x-coordinate in world space (meters).
- `y`: The y-coordinate in world space (meters).

# Returns
- `true` if the location is occupied, `false` otherwise.

# Throws
- `MethodError` if not implemented by a concrete type.
- `BoundsError` if the coordinates are outside the grid boundaries.
"""
function is_occupied(grid::OccupancyGrid, x::Real, y::Real)
    throw(MethodError(is_occupied, (grid, x, y)))
end



# Convenience methods that forward to the main method
"""
    is_occupied(grid::OccupancyGrid, point::Tuple{<:Real,<:Real}) -> Bool
    is_occupied(grid::OccupancyGrid, point::AbstractVector{<:Real}) -> Bool

Convenience methods to check for occupancy using a tuple or vector of coordinates.
"""
is_occupied(grid::OccupancyGrid, point::Tuple{<:Real,<:Real}) = is_occupied(grid, point[1], point[2])
is_occupied(grid::OccupancyGrid, point::AbstractVector{<:Real}) = is_occupied(grid, point[1], point[2])


"""
    sdf(grid::OccupancyGrid, x::Real, y::Real) -> Float64

Returns the signed distance field value for the location (x, y) in world coordinates. 
Returns 0 if the location is occupied, positive values for free space indicating 
distance to nearest obstacle.
"""
function sdf(grid::OccupancyGrid, x::Real, y::Real)
    throw(MethodError(sdf, (grid, x, y)))
end

"""
    sdf(grid::OccupancyGrid, point::Tuple{<:Real,<:Real}) -> Float64
    sdf(grid::OccupancyGrid, point::AbstractVector{<:Real}) -> Float64

Convenience methods to compute the signed distance field using a tuple or vector of coordinates.
"""
sdf(grid::OccupancyGrid, point::Tuple{<:Real,<:Real}) = sdf(grid, point[1], point[2])
sdf(grid::OccupancyGrid, point::AbstractVector{<:Real}) = sdf(grid, point[1], point[2])
# Get physical dimensions of the grid in world coordinates
"""
    Base.size(grid::OccupancyGrid) -> Tuple{Float64, Float64}

Get the physical size of the occupancy grid in world coordinates (meters).

This function must be implemented by concrete subtypes of `OccupancyGrid`.

# Returns
A tuple `(width, height)` where width and height are in meters.

# Throws
- `MethodError` if not implemented by a concrete type.
"""
function Base.size(grid::OccupancyGrid)
    throw(MethodError(size, (grid,)))
end




end # module Types
