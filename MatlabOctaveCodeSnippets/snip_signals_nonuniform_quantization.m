x=-5 %define input
if x < -0.5
    if x < -2.5
        x_quantized = -4 %output if x in ]-Inf, -2.5[
    else
        x_quantized = -1 %output if x in [-2.5, -0.5[
    end
else
    if x < 1.5
        x_quantized = 0 %output if x in [-0.5, 1.5[
    else
        x_quantized = 3 %output if x in [1.5, Inf[
    end
end
