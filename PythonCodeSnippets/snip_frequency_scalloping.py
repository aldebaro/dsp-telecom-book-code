import numpy as np
import matplotlib.pyplot as plt


def ak_impulseplot(x, t=None, T=None, **kwargs):
    """
    Plots the time series x as impulses. The abscissa is t as time-axis or
    generated automatically with T as sampling interval.
    """
    # Example usage:
    # x = [1, 2, -3]
    # t = np.arange(1, 3, 0.5)
    # ak_impulseplot(x, t, color='r')

    # Example with sampling interval T
    # T = 0.5
    # ak_impulseplot(x, T=T, color='b')

    # Check syntax
    if t is None:
        if T is None:
            raise ValueError(
                "You need to specify the time-axis t or the sampling interval T"
            )
        if not isinstance(T, (int, float)):
            raise ValueError("Syntax error: T must be numeric (when specified)")
        # generate time-axis
        t = np.arange(0, len(x) * T, T)
    else:
        if T is not None:
            raise ValueError(
                "You cannot specify both the time-axis t and the sampling interval T. Check the syntax"
            )

    # Use blue if color is not specified
    color = kwargs.get("color", "b")

    # Convert x to a numpy array for comparison
    x = np.array(x)
    t = np.array(t)

    # Plot impulses
    indices_pos = np.where(x > 0)[0]
    indices_neg = np.where(x < 0)[0]
    indices_zero = np.where(x == 0)[0]

    if indices_pos.size > 0:
        axs[0].stem(
            t[indices_pos],
            x[indices_pos],
            linefmt=f"{color}-",
            markerfmt=f"{color}^",
            basefmt=" ",
            label="Positive Impulses",
        )
    if indices_neg.size > 0:
        axs[0].stem(
            t[indices_neg],
            x[indices_neg],
            linefmt=f"{color}-",
            markerfmt=f"{color}v",
            basefmt=" ",
            label="Negative Impulses",
        )
    if indices_zero.size > 0:
        axs[0].stem(
            t[indices_zero],
            x[indices_zero],
            linefmt=f"{color}-",
            markerfmt=f"{color}o",
            basefmt=" ",
            label="Zero Impulses",
        )

    axs[0].axhline(y=0, color="black", linestyle="-", linewidth=1)
    axs[0].set_xlabel("Time (s)")
    axs[0].set_ylabel("Amplitude")


# Main code
N = 32  # FFT length
A = 6  # cosine amplitude
alpha = 8.5
Wc = (alpha * 2 * np.pi) / N  # cosine frequency in radians
n = np.arange(0, N)  # generate N samples of the cosine
x = A * np.cos(Wc * n)

window_choice = 1  # choose one among 3 possible windows

if window_choice == 1:
    this_window = np.ones(N)
elif window_choice == 2:
    this_window = np.hanning(N)
elif window_choice == 3:
    this_window = np.flattopwin(N)

amplitude_scaling = np.sum(this_window)  # factor to mitigate scalloping
xw = x * this_window  # multiply in time-domain
Xw_scaled_fft = np.fft.fft(xw) / amplitude_scaling  # N-points FFT and scale it
max_fft_amplitude = np.max(np.abs(Xw_scaled_fft))
print(f"Max(abs(scaled FFT)) = {max_fft_amplitude}")
scalloping_loss = (A / 2) - max_fft_amplitude
print(f"Scalloping loss = {scalloping_loss}")
print(f"Correct amplitude (Volts) = {A}")
print(f"Estimated amplitude (Volts) = {2 * max_fft_amplitude}")
amplitude_error = A - 2 * max_fft_amplitude
print(f"Amplitude error (Volts) = {amplitude_error}")
print(f"Amplitude error (%) = {100 * amplitude_error / A}")

# Subplots configuration
fig, axs = plt.subplots(1, 2, figsize=(12, 5))

# Impulse Plot
axs[0].set_title("Impulse Plot")
ak_impulseplot([A / 2, A / 2], [Wc / np.pi, (2 * np.pi - Wc) / np.pi])

axs[1].set_title("FFT Magnitude")
axs[1].stem(
    np.arange(N) * (2 * np.pi / N) / np.pi,
    np.abs(Xw_scaled_fft),
    "or",
    label="FFT Magnitude",
)
axs[1].set_xlabel("Frequency $\\Omega$ (rad) normalized by $\\pi$")
axs[1].set_ylabel("FFT magnitude and impulse area scaled by $\\pi$")
axs[1].grid(True)

plt.show()
