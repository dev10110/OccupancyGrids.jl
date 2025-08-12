using OccupancyGrids
using Printf

simple_one = load_grid(SimpleIndoor1; compute_sdf=true, inflation=0.0)
println("Simple Indoor 1 Grid Size: ", size(simple_one))
println("SDF at (0.5, 0.5): ", sdf(simple_one, (0.5, 0.5)))

# Print SDF grid for points between [0.0, 0.0] and [1.0, 1.0] with 0.1 resolution
println("\nSDF Grid (y increases upward, x increases rightward):")
println("Format: each cell shows a colored # symbol")
println("Colors: Red = 0.0 (obstacles), Yellow = low values, Green = medium, Blue = high values")
println()

# Define color functions
function get_color_code(sdf_val::Float64)
    if sdf_val == 0.0
        return "\033[91m"  # Bright red for obstacles
    elseif sdf_val < 0.1
        return "\033[93m"  # Bright yellow for very close to obstacles
    elseif sdf_val < 0.2
        return "\033[92m"  # Bright green for medium distance
    else
        return "\033[94m"  # Bright blue for far from obstacles
    end
end

const RESET_COLOR = "\033[0m"

# Create coordinate ranges
x_range = 0.0:0.05:2.0
y_range = 2.0:-0.05:0.0  # Reverse order so y increases upward in display

# # Print header with x coordinates (every 4th one to save space)
# print("   ")  # Space for y labels
# for (i, x) in enumerate(x_range)
#     if i % 4 == 1  # Print every 4th x coordinate
#         @printf("%2.1f", x)
#     else
#         print("  ")
#     end
# end
# println()

# Print each row
for y in y_range
    # @printf("%2.1f ", y)  # Y coordinate label
    for x in x_range
        try
            sdf_val = sdf(simple_one, x, y)
            color_code = get_color_code(sdf_val)
            @printf("%s#%s ", color_code, RESET_COLOR)
        catch e
            print("? ")  # Out of bounds or other error
        end
    end
    println()
end
