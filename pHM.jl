#############################
#           pHM.jl          #
#          pH-Mouse         #
#     @author Tanner Lee    #
#      @date 9/27/2018      #
#############################

# Initialize Luxor
println("!Initializing Luxor Package!")
using Luxor
println("!Luxor Initialized!")
Drawing(1250, 1250, "images/pHM.png")
origin()
background("white")

# Initialize Table and digits
table = Table(25, 25, 50, 50) # 10 rows, 10 columns, 50 wide, 35 high
digits = 1:625

# Print black text in the grid
sethue("black")
for n in 1:length(table)
   text(string(digits[n]), table[n], halign=:center, valign=:middle)
end

# Print black borders on each of the grid boxes
setopacity(0.5)
sethue("black")
for index in table
    box.(index[1], 50, 50, :stroke) # row 3, every column
end

# Finish the image
println("!Printing to file!")
finish()
println("!Completed!")
