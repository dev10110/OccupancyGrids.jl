# OccupancyGrids.jl

[![CI](https://github.com/mvielmetti/OccupancyGrids.jl/actions/workflows/CI.yml/badge.svg)](https://github.com/mvielmetti/OccupancyGrids.jl/actions/workflows/CI.yml)

A Julia package for working with occupancy grids.

## Installation

```julia
using Pkg
Pkg.add("OccupancyGrids")
```

## Usage

This package provides a set of tools for working with occupancy grids. The core type is `AbstractOccupancyGrid`, which can be instantiated as a `DenseOccupancyGrid`.

### Loading a Map

The main way to interact with this package is to load a grid from a file. Currently, only grids that are included with the package are supported.

```julia
using OccupancyGrids

# Load the Willow Garage map
grid = load_grid(WillowGarage) # WillowGarage is an enum of tyope IncludedMaps
```

### Checking for Occupancy

Once you have a grid, you can check if a particular location is occupied:

```julia
is_occupied(grid, 0.5, 1.2)  # Returns true or false
is_occupied(grid, (0.5, 1.2))
is_occuped(grid, [0.5, 1.2])
```

## Supported Maps

### Willow Garage

<img src="maps/willow_garage/willow_garage.jpg" width="400"/>
