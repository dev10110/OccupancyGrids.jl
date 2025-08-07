
# Based on https://netpbm.sourceforge.net/doc/pgm.html

function load_pgm(file_path::AbstractString)
    # Verify that the file extension is .pgm
    if !endswith(file_path, ".pgm")
        throw(ArgumentError("File must be a .pgm file"))
    end

    # Open the file and read its contents
    pixel_data = open(file_path, "r") do file
        magic_number = strip(readline(file))
        if !(cmp(magic_number, "P5") == 0)
            throw(ArgumentError("Invalid PGM file -- $(magic_number) != P5"))
        end

        # Read comments
        line = ""
        while true
            line = readline(file)
            # process the line here
            if !startswith(line, "#")  # Skip comments
                break
            end
        end

        # Read width, height, and max value
        dimensions = split(line)
        if length(dimensions) != 2
            @show dimensions
            throw(ArgumentError("Invalid PGM file -- dimensions wrong"))
        end
        width, height = parse.(Int, dimensions)

        max_value = parse(Int, readline(file))
        @assert 0 < max_value <= 25565 # Requirements for PGM files

        if max_value < 256
            data_type = UInt8
        else
            data_type = UInt16
        end

        # Read the pixel data into a (width, height) matrix
        pixel_data = Vector{data_type}(undef, width * height)
        read!(file, pixel_data)
        return reshape(pixel_data, (height, width))
    end
end