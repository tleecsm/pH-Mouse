#############################
#           pHM.jl          #
#          pH-Mouse         #
#     @author Tanner Lee    #
#      @date 9/27/2018      #
#############################

# Start by loading the initializing data in memory
using DelimitedFiles
print("Which input number would you like to load? \t")
input = readline(stdin)
print("How many iterations would you like to run? \t")
iterations = readline(stdin)
iterations = parse(Int64, iterations)
print("Which room would you like to start in? \t\t")
startingLocation = readline(stdin)
startingLocation = parse(Int64, startingLocation)
print("Enter an intensity for the heatmap {1-10}: \t")
intensity = readline(stdin)
intensity = parse(Int64, intensity)
input = "input" * input * ".phm"
println("!CLEARING TMP FOLDER!")
rm("./tmp", force=true, recursive=true)
mkdir("./tmp")
println("!TMP SUCCESSFULLY CLEARED!")
println("!IMPORTING DATA FROM $input !")
A = readdlm(input, String)
println("!DATA IMPORTED SUCCESSFULLY!")

Arows = size(A)[1]
Acols = size(A)[2]

# Create the transpose manually
# Julia cannot transpose a string matrix
Atrans = Array{String}(undef, Arows, Acols)
for i=1:Arows
    for j=1:Acols
        Atrans[j,i] = A[i,j]
    end
end

println(A)
println(Atrans)

# Create an empty matrix we can concat with
# The columns we want are the pivot columns
probMatrix = zeros(Arows*Acols,Arows*Acols)

# Parse through A to create probability matrix
for i=1:Arows       # 1 < i < rows
    for j=1:Acols   # 1 < j < cols
        global A
        global probMatrix
        up = false
        down = false
        right = false
        left = false
        upDigit = 0
        downDigit = 0
        leftDigit = 0
        rightDigit = 0
        probCounter = 0
        tempString = ""
        tempRoomNumber = 0
        currentRoomString = A[i,j]
        currentRoomNumber = chop(currentRoomString)
        currentRoomNumber = parse(Int64,currentRoomNumber)
        # Check if the current room is a wall, or cheese
        if (string(currentRoomString[length(currentRoomString)]) == "W")
            # Current Room is a wall
            continue
        elseif (string(currentRoomString[length(currentRoomString)]) == "C")
            # Current Room is cheese
            probMatrix[currentRoomNumber,currentRoomNumber] = 1.0
            continue
        end
        # Check how many neighbors A[i,j] has
        # A[i,j] has neighbors at --
        # A[i+1,j], A[i-1,j], A[i,j+1], A[i,j-1]
        # However all of these may not exist
        # Boundary conditions must be considered
        if i != 1
            # We are not on the top row, decrease row
            tempString = A[i-1,j]
            # Get the room number from this neighbor
            tempRoomNumber = chop(tempString)
            # Ensure this room isnt a wall
            if (string(tempString[length(tempString)]) != "W")
                # We can enter this room
                probCounter += 1
                up = true
                upDigit = parse(Int64,tempRoomNumber)
            end
        end
        if i != Arows
            # We are not on the last row, increase row
            tempString = A[i+1,j]
            # Get the room number from this neighbor
            tempRoomNumber = chop(tempString)
            # Ensure this room isnt a wall
            if (string(tempString[length(tempString)]) != "W")
                # We can enter this room
                probCounter += 1
                down = true
                downDigit = parse(Int64,tempRoomNumber)
            end
        end
        if j != 1
            # We are not on the first col, decrease col
            tempString = A[i,j-1]
            # Get the room number from this neighbor
            tempRoomNumber = chop(tempString)
            # Ensure this room isnt a wall
            if (string(tempString[length(tempString)]) != "W")
                # We can enter this room
                probCounter += 1
                left = true
                leftDigit = parse(Int64,tempRoomNumber)
            end
        end
        if j != Acols
            # We are not on the last col, increase col
            tempString = A[i,j+1]
            # Get the room number from this neighbor
            tempRoomNumber = chop(tempString)
            # Ensure this room isnt a wall
            if (string(tempString[length(tempString)]) != "W")
                # We can enter this room
                probCounter += 1
                right = true
                rightDigit = parse(Int64,tempRoomNumber)
            end
        end
        # Create this rooms column in the probability matrix
        if (up)
            # We can go up
            probMatrix[upDigit,currentRoomNumber] = 1/probCounter
        end
        if (down)
            probMatrix[downDigit,currentRoomNumber] = 1/probCounter
        end
        if (left)
            probMatrix[leftDigit,currentRoomNumber] = 1/probCounter
        end
        if (right)
            probMatrix[rightDigit,currentRoomNumber] = 1/probCounter
        end
    end
end

# We now have a probability matrix for our maze
# Create some an input for it
x = zeros(Arows*Acols,1)
x[startingLocation] = intensity

# Use the following code segment to print the probMatrix
# For debugging purposes only
#=
sizeProbMatrix = size(probMatrix)
for i=1:sizeProbMatrix[1]
    print("Row $i:\t [")
    for j=1:15
        print(probMatrix[i,j])
        print(", ")
    end
    println("]")
end
=#

# Complete Luxor Initialization
# Initialize Room Size in pixels
global rSize = 100
# Initialize Canvas Size
global cSize = rSize*Arows
println("!INITIALIZING LUXOR!")
using Luxor
animation = Movie(cSize, cSize, "pHM", 1:iterations)
println("!LUXOR INITIALIZED!")
println("!INITIALIZING COLORSCHEMES!")
using Colors, ColorSchemes
println("!COLORSCHEMES INITIALIZED!")

# Run the simulation
println("!INITIAL INPUT!")
println(x)
println("!STARTING SIMULATION!")

function backdrop(scene, framenumber)
    background("white")
    # Initialize Table and digits
    global table = Table(Arows, Acols, rSize, rSize)
    sethue("black")
    # Loop through each room of the maze and print it to the image
    for i in 1:length(table)
        if (string(Atrans[i][length(Atrans[i])]) == "W")
            # If the current room is a wall make it grey
            box.(table[i], rSize, rSize, :fill)
        end
        # Put a black border on the room and print its name in the middle
        text(Atrans[i], table[i], halign=:center, valign=:middle)
        box.(table[i], rSize, rSize, :stroke)
    end
end

function frame(scene, framenumber)
    global table
    global rSize
    global x
    global probMatrix
    for i=1:length(x)
        sethue(get(ColorSchemes.YlOrRd_7, x[i]))
        setmode("darken")   # Set mode to darken to ensure text isnt covered
        box.(table[i], rSize, rSize, :fill)
    end
    x = probMatrix*x
end

animate(animation, [
    Scene(animation, backdrop, 0:iterations),
    Scene(animation, frame, 0:iterations)],
    creategif=true,
    framerate=20,
    pathname="./images/pHM.gif",
    tempdirectory="./tmp")

println("!SIMULATION COMPLETE!")
println("!FINAL OUTPUT!")
println(x)
println()
