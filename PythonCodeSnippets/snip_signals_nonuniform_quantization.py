x = -5
if x < -0.5:
    if x < -2.5:
        x_quantized = -4
    else:
        x_quantized = -1
else:
    if x < 1.5:
        x_quantized = 0
    else:
        x_quantized = 3

print(x_quantized)
