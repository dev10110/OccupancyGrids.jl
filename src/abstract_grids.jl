module AbstractGrids

export AbstractOccupancyGrid, is_occupied

abstract type AbstractOccupancyGrid end

# Main method that concrete types should implement
function is_occupied(grid::AbstractOccupancyGrid, x::Real, y::Real)
    throw(MethodError(is_occupied, (grid, x, y)))
end

# Convenience methods that forward to the main method
is_occupied(grid::AbstractOccupancyGrid, point::Tuple{<:Real,<:Real}) = is_occupied(grid, point[1], point[2])
is_occupied(grid::AbstractOccupancyGrid, point::AbstractVector{<:Real}) = is_occupied(grid, point[1], point[2])

# Get physical dimensions of the grid in world coordinates
"""
    Get the size of the occupancy grid in world coordinates (meters).
    Returns a tuple (width, height) where width and height are in meters.
"""
function Base.size(grid::AbstractOccupancyGrid)
    throw(MethodError(size, (grid,)))
end




end # module Types