#############################
#           pHM.jl          #
#          pH-Mouse         #
#     @author Tanner Lee    #
#      @date 9/27/2018      #
#############################

# Start by loading the initializing data in memory
using DelimitedFiles
println("!IMPORTING DATA FROM input.phm!")
A = readdlm("input.phm", String)
println("!DATA IMPORTED SUCCESSFULLY!")

Arows = size(A)[1]
Acols = size(A)[2]

iterations = 100

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
        println(currentRoomString)
        println(currentRoomString[length(currentRoomString)])
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
x[5] = 10

# Use the following code segment to print the probMatrix
# For debugging purposes only

for i=1:25
    print("Row $i:\t [")
    for j=1:15
        print(probMatrix[i,j])
        print(", ")
    end
    println("]")
end


#=
# Run the simulation
for i=1:iterations
    global x
    global probMatrix
    x = probMatrix*x
    println(x)
end
=#

println(x)

#=
# Initialize Room Size in pixels
rSize = 100
# Initialize Canvas Size
cSize = rSize*5

# Initialize Luxor
println("!INITIALIZING LUXOR PACKAGE!")
using Luxor
println("!LUXOR INITIALIZED!")
Drawing(cSize, cSize, "images/pHM.png")
origin()
background("white")

# Initialize Table and digits
table = Table(5, 5, rSize, rSize) # 5 rows, 5 columns, 50 wide, 35 high
digits = 1:25

# Print black text in the grid
sethue("black")
for n in 1:length(table)
   text(string(digits[n]), table[n], halign=:center, valign=:middle)
end

# Print black borders on each of the grid boxes
setopacity(1.0)
sethue("black")
for index in table
    box.(index[1], rSize, rSize, :stroke) # row 3, every column
end

# Finish the image
println("!PRINTING OUTPUT IMAGE!")
finish()
println("!PRINTING COMPLETED!")
=#
