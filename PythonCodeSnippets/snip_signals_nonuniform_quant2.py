x = 2.3  # defing a input
output_levels = [-4, -1, 0, 3]  # Defining the output levels

# Getting the squared erros of each output level with the input
squared_errors = []
for i in range(4):
    squared_errors.append((output_levels[i] - x) ** 2)

# Getting the index of the output level that has the minimun squared error
value_min = min(squared_errors)
index_min = min(range(len(squared_errors)), key=squared_errors.__getitem__)

# Put the output level that has the minimun squared error as the quantized
# value of the imput
x_quantized = output_levels[index_min]
print(x_quantized)
