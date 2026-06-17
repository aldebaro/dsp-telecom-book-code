import math
import numpy as np


def fixed_point_conversion(x, b, b_f, mode="round"):
    """
    Fixed-point conversion for signed numbers with b bits:
    one bit for the sign and b_f fractional bits.
    The representable range is [-2^(b-1), 2^(b-1)-1].
    Returns: x_b, x_i, x_q
            x_b: binary representation with b bits
            x_i: x_q represented as an integer
            x_q: decoded quantized value
    alternatives for "mode":
        "floor" -> floor(-3.8) = -4 and floor(3.8) = 3
        "round" -> round to nearest integer, e.g., round(-3.8) = -4, round(3.8) = 4, round(-3.5) = -4, round(3.5) = 4
        "trunc" -> truncate toward zero, e.g., trunc(-3.8) = -3, trunc(3.8) = 3
    """
    # make sure x is a scalar and float
    x = np.asarray(x)
    if x.size != 1:
        raise ValueError(
            "fixed_point_conversion expects a scalar. Pass one coefficient at a time.")
    x = float(x.item())

    Delta = 2 ** (-b_f)  # quantization step size

    number_of_deltas = x / Delta

    if mode == "floor":
        x_i = math.floor(number_of_deltas)
    elif mode == "round":
        x_i = round(number_of_deltas)
    elif mode == "trunc":
        x_i = int(number_of_deltas)
    else:
        raise ValueError("mode must be 'floor', 'round', or 'trunc'")

    # Scaled-integer range for signed fixed-point with 1 sign bit
    min_int = -(2 ** (b-1))
    max_int = (2 ** (b-1)) - 1

    if x_i < min_int:  # check minimum representable value
        x_i = min_int
        print("Warning! Consider increasing b_i")

    if x_i > max_int:  # check maximum representable value
        x_i = max_int
        print("Warning! Consider increasing b_i")

    x_q = x_i * Delta  # quantized value scaled back to original range

    if x_i < 0:
        # complement 2's representation for negative numbers
        # Two's complement of -N is: 2^b - N
        # Since (1 << b) = 2^b, the expression becomes: 2^b + (-N) = 2^b - N
        x_b = format((1 << b) + x_i, f"0{b}b")
    else:
        x_b = format(x_i, f"0{b}b")

    return x_b, x_i, x_q


if __name__ == "__main__":
    # Example
    input_values = [5.0625, 0.6328125, -7.45, 2804.6542]
    b_f_values = [4, 7, 4, 3]
    b_values = [8, 8, 8, 16]
    for x, b, b_f in zip(input_values, b_values, b_f_values):
        print("\nInput: x =", x, ", b =", b, ", b_f =",
              b_f, ", # bits for integer part m =", b-1-b_f)
        x_b, x_i, x_q = fixed_point_conversion(x, b, b_f)

        print("x_b =", x_b)
        print("x_i =", x_i)
        print("x_q =", x_q)
        print("x =", x)
        print("error=x-x_q =", x-x_q)
