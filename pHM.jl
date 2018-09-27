#############################
#           pHM.jl          #
#          pH-Mouse         #
#     @author Tanner Lee    #
#      @date 9/27/2018      #
#############################

# Initialize Luxor
using Luxor
Drawing(500, 500, "images/pHM.png")
origin()
background("white")

randomhue()
text("HELLOWORLD!")

println("Printing to file!")
finish()
println("Completed!")
