x=2.3 %define input
output_levels = [-4, -1, 0, 3];
squared_errors = (output_levels - x).^2;
[min_value, min_index] = min(squared_errors);
x_quantized = output_levels(min_index)
