#############################
#           pHM.jl          #
#          pH-Mouse         #
#     @author Tanner Lee    #
#      @date 9/27/2018      #
#############################

# Initialize Room Size
rSize = 100
# Initialize Canvas Size
cSize = rSize*5

# Initialize Luxor
println("!Initializing Luxor Package!")
using Luxor
println("!Luxor Initialized!")
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
println("!Printing to file!")
finish()
println("!Completed!")
