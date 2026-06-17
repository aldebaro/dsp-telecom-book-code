import numpy as np
from scipy.signal import butter, lfilter
import matplotlib.pyplot as plt

from scipy.signal import freqz
import numpy as np
import matplotlib.pyplot as plt

from ak_fixed_point_quantization import fixed_point_conversion

import numpy as np


def saturate_int16(x):
    return np.int16(np.clip(x, -32768, 32767))


def saturate_int8(x):
    return np.int8(np.clip(x, -128, 127))


def int8_fixed_to_float(x_i, frac_bits):
    """
    Convert signed int8 fixed-point representation back to float.
    """
    return np.asarray(x_i, dtype=np.float64) / (2 ** frac_bits)


def quantize_array(x, b, b_f, mode="round"):
    """
    Quantize all elements of an array x to fixed-point representation.

    Parameters
    ----------
    x : array elements to quantize
    b : int
        Total number of bits for fixed-point representation (including sign bit).
    b_f : int
        Number of bits for the fractional part.
    mode : str, optional
        Rounding mode: "floor", "round", or "trunc". Default is "round".
    Returns
    -------
    coefficients_quantized : ndarray
        Quantized coefficients.
     Note: For IIR filters, A[0] is typically 1 for normalized filters, so it may not need quantization.
     """
    if np.isscalar(x):
        x = np.array([x])
    x_quantized = []
    x_as_integers = []
    for x in x:
        x_b, x_i, x_q = fixed_point_conversion(x, b, b_f, mode=mode)
        x_quantized.append(x_q)
        x_as_integers.append(x_i)

    return np.array(x_quantized), np.array(x_as_integers)


def compare_frequency_responses(B, A, Bq, Aq, worN=1024):
    """
    Compare frequency responses of unquantized and quantized IIR filters.

    B, A   : unquantized numerator and denominator
    Bq, Aq : quantized numerator and denominator
    worN   : number of frequency samples
    """

    w, H = freqz(B, A, worN=worN)
    _, Hq = freqz(Bq, Aq, worN=worN)

    f = w / np.pi  # normalized frequency, where 1 corresponds to Nyquist

    mag_db = 20 * np.log10(np.maximum(np.abs(H), 1e-12))
    magq_db = 20 * np.log10(np.maximum(np.abs(Hq), 1e-12))

    phase = np.unwrap(np.angle(H))
    phaseq = np.unwrap(np.angle(Hq))

    plt.figure()
    plt.plot(f, mag_db, label="Unquantized")
    plt.plot(f, magq_db, "--", label="Quantized")
    plt.xlabel(r"Normalized frequency $\omega/\pi$")
    plt.ylabel("Magnitude (dB)")
    plt.title("Magnitude response")
    plt.grid(True)
    plt.legend()

    plt.figure()
    plt.plot(f, phase, label="Unquantized")
    plt.plot(f, phaseq, "--", label="Quantized")
    plt.xlabel(r"Normalized frequency $\omega/\pi$")
    plt.ylabel("Phase (rad)")
    plt.title("Phase response")
    plt.grid(True)
    plt.legend()

    plt.figure()
    plt.plot(f, magq_db - mag_db)
    plt.xlabel(r"Normalized frequency $\omega/\pi$")
    plt.ylabel("Magnitude error (dB)")
    plt.title("Quantization error in magnitude response")
    plt.grid(True)

    plt.show()

    return w, H, Hq


def apply_fixed_point_filter(B, A, x, total_bits=8, frac_bits=3,
                             acc_bits=16, acc_frac_bits=6, mode="round"):
    '''
    Apply fixed-point IIR filter to input signal x using quantized
    coefficients B and A.
    It assumes an accumulator with acc_bits total bits and acc_frac_bits
    fractional bits to prevent overflow during intermediate calculations.
    '''

    M = len(B) - 1
    N = len(A) - 1

    y = np.zeros_like(x)

    for n in range(0, len(x)):
        acc = 0.0

        for i in range(M + 1):
            if n - i >= 0:
                acc += B[i] * x[n - i]
                _, _, acc = fixed_point_conversion(
                    acc, acc_bits, acc_frac_bits, mode="round")

        for i in range(1, N + 1):
            if n - i >= 0:
                acc -= A[i] * y[n - i]
                _, _, acc = fixed_point_conversion(
                    acc, acc_bits, acc_frac_bits, mode="round")

        _, _, y[n] = fixed_point_conversion(
            acc, total_bits, frac_bits, mode="round")

    return y


def apply_fixed_point_filter_int8(B, A, x, frac_bits=3, mode="round"):
    """
    Fixed-point IIR filter using:
      - int8 for x, B, A and y
      - int16 for accumulator

    All multiplications generate Q(2*frac_bits).
    Before storing y[n] as int8, the accumulator is shifted right by frac_bits.
    """
    # quantize filter coefficients to int8 fixed-point representation
    B_q, B_i = quantize_array(B, 8, frac_bits, mode=mode)
    A_q, A_i = quantize_array(A, 8, frac_bits, mode=mode)
    # quantize input signal to int8 fixed-point representation
    x_q, x_i = quantize_array(x, 8, frac_bits, mode=mode)

    M = len(B_i) - 1
    N = len(A_i) - 1

    y_i = np.zeros(len(x_i), dtype=np.int8)

    for n in range(len(x_i)):
        acc = np.int16(0)

        for k in range(M + 1):
            if n - k >= 0:
                prod = np.int16(B_i[k]) * np.int16(x_i[n - k])
                acc = saturate_int16(np.int32(acc) + np.int32(prod))

        for k in range(1, N + 1):
            if n - k >= 0:
                prod = np.int16(A_i[k]) * np.int16(y_i[n - k])
                acc = saturate_int16(np.int32(acc) - np.int32(prod))

        # acc is in Q(2*frac_bits)
        # y_i must be in Q(frac_bits)
        acc_shifted = acc >> frac_bits

        y_i[n] = saturate_int8(acc_shifted)

    y = int8_fixed_to_float(y_i, frac_bits)

    return y, y_i, x_i, B_i, A_i


def figs_systems_roundoff_errors():
    np.random.seed(0)

    N = 300
    x = 10 * np.cos(np.pi * 0.2 * np.arange(N))
    # x = 32 * np.random.randn(N)

    M = 4
    B, A = butter(M, 0.3)

    # 8-bit Q4.3 variables and coefficients
    total_bits = 8
    frac_bits = 3

    # 16-bit accumulator with 6 fractional bits
    acc_bits = 16
    acc_frac_bits = 2 * frac_bits

    xq, xi = quantize_array(x, total_bits, frac_bits, mode="round")
    Bq, Bi = quantize_array(
        B, total_bits, frac_bits, mode="round")
    Aq, Ai = quantize_array(
        A, total_bits, frac_bits, mode="round")

    if np.sum(np.abs(Bq)) == 0 or np.sum(np.abs(Aq)) == 0:
        raise RuntimeError(
            "Quantized filter has B(z) or A(z) only with zero values.")

    w, H, Hq = compare_frequency_responses(B, A, Bq, Aq)

    yq_my = apply_fixed_point_filter(Bq, Aq, xq,
                                     total_bits=total_bits,
                                     frac_bits=frac_bits,
                                     acc_bits=acc_bits,
                                     acc_frac_bits=acc_frac_bits,
                                     mode="round")

    y_my = apply_fixed_point_filter(B, A, x,
                                    total_bits=64,
                                    frac_bits=40,
                                    acc_bits=64,
                                    acc_frac_bits=40,
                                    mode="round")

    y_scipy = lfilter(B, A, x)

    y_int8, _, _, _, _ = apply_fixed_point_filter_int8(
        Bq, Aq, xq, frac_bits=frac_bits, mode="round")

    n = np.arange(N)

    plt.figure()
    plt.plot(n, yq_my, linewidth=3, label="Quantized my_filter")
    plt.plot(n, y_my, "o-", label="Float my_filter")
    plt.plot(n, y_scipy, "x-", label="scipy.signal.lfilter")
    plt.plot(n, y_int8, "s-", label="Int8 my_filter")
    plt.xlabel("n")
    plt.ylabel("Filter output y[n]")
    plt.legend()
    plt.grid(True)
    plt.show()

    return yq_my, y_my, y_scipy, Bq, Aq, xq


if __name__ == "__main__":
    yq_my, y_my, y_scipy, Bq, Aq, xq = figs_systems_roundoff_errors()

    print("Quantized B =", Bq)
    print("Quantized A =", Aq)
