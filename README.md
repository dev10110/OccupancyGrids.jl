# OccupancyGrids.jl

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

### Simple Indoor 1

<img src="maps/simple_indoor_1/simple_indoor_1.png" width="400"/>

## Creating a Compatible Map w/Illustrator

1. Create a desired map
2. Export As a PNG file, using a white background & high PPI settings
3. Using Imagemagick, run:
```bash
magick 
```

## Adding an Environment to the Package
1. Create the folder in the maps/ directory
2. Add an enum entry in 'src/load_grid.jl'
3. Add a dict entry in 'src/load_grid.jl'
4. Export the enum from LoadGrid and OccupancyGrid modules
