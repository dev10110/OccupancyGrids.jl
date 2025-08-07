module LoadGrid
"""
    LoadGrid

This module provides functionality for loading and working with occupancy grids.

Grids can be loaded from various sources:
1. A directory containing a 'grid_info.yaml' file with metadata, and the actual grid data files.
2. A GridInfo object that contains the necessary metadata, and the data object (passed seperately).
3. Pass an IncludedGrid enum value to load an included grid object.
"""

export load_grid, GridInfo

using StaticArrays
using Base.Enums

using ..FileUtil

export IncludedGrid, WillowGarage
@enum IncludedGrid WillowGarage

const BASE_PATH = joinpath(@__DIR__, "..", "maps")

const INCLUDED_GRID_INFO = Dict(
    WillowGarage => joinpath(BASE_PATH, "willow_garage")
)

struct GridInfo
    file_type::String
    grid_file::String

    resolution::Float64
    origin::SVector{3,Float64}
    negate::Bool
    occuped_threshold::Float64
    free_threshold::Float64
end

"""
    load_grid(grid::IncludedGrid)
Load a grid from the included grids defined in `INCLUDED_GRID_INFO`.
"""
function load_grid(grid::IncludedGrid)
    return load_grid(INCLUDED_GRID_INFO[grid])
end

"""
    load_grid(directory::AbstractString)
Load a grid from a directory containing a 'grid_info.yaml' file and the grid data files
"""
function load_grid(directory::AbstractString)
    info = load_grid_info(directory)
    data = load_grid_data(directory, info)
    return load_grid(info, data)
end

function load_grid(info::GridInfo, data)
    throw(MethodError(load_grid, (info, data)))
end


function load_grid_info(directory::AbstractString)::GridInfo
    info_path = joinpath(directory, "grid_info.yaml")

    info = YAML.load_file(info_path)

    file_type = get(info, "file_type", "pgm")
    grid_file = get(info, "grid_file", "grid.pgm")

    resolution = get(info, "resolution", 0.1)
    origin = get(info, "origin", [0.0, 0.0, 0.0])
    negate = get(info, "negate", false)

    occupied_threshold = get(info, "occupied_threshold", 0.65)
    free_threshold = get(info, "free_threshold", 0.35)

    return GridInfo(file_type, grid_file, resolution, SVector{3,Float64}(origin), negate, occupied_threshold, free_threshold)
end

function load_grid_data(directory::AbstractString, info::GridInfo)
    data_path = joinpath(directory, info.grid_file)
    if info.file_type == "pgm"
        return load_pgm(data_path)
    end

    throw(ArgumentError("Unsupported file type: $(info.file_type)"))
end


end # module LoadGrid