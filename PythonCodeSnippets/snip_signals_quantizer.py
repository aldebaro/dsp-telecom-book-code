#### Considering values maximum and min of a input
Xmin = -1
Xmax = 3

b = 2  # Number o quantizer's bits
M = 2 ** b  # Number of output levels

delta = abs((Xmax - Xmin) / (M - 1))  # Calculating the quantization step
print(delta)
####Get the output values
quantizer_levels = []
for i in range(M):
    quantizer_levels.append(Xmin + i * delta)

####Discover if there is 0 in the output values
# @TODO use np.find or similar to check existence of a zero
aux = 0
if 0 in quantizer_levels:
    aux = 1

####Fix the output leves if theres is no 0 value
if aux == 0:
    new_quantizer_levels = []

    ###Get the number of negatives output values
    Nneg = 0
    for i in range(len(quantizer_levels)):
        if quantizer_levels[i] < 0:
            Nneg += 1

    Xmin = -Nneg * delta  # Update de minimun value
    print(Xmin, Nneg)
    # for i in range(M):
    # new_quantizer_levels.append(Xmin + i * delta)
    print(new_quantizer_levels)
