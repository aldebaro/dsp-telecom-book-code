import matplotlib.pyplot as plt
import numpy as np
import pylab as pl


# creating the digital signal and simulating a D/A conversion
digital = np.array([13, 126, 3, 34, 254])  # signal as 8-bits unsigned[0, 255]
n = np.arange(0, 5)  # sample instants in the digital domain
fs = 8000  # sampling frequency
delta = 0.78e-3  # step size in Volts
analog = (digital-128) * delta  # subtract offset=128 and normalize by delta
ts = 1 / fs  # Sampling interval in seconds
time = n * ts  # normalize abscissa
# creating the analog signal plot
plt.subplot(211)
plt.stem(time, analog)
plt.xlabel("time(s)")
plt.ylabel("amplitude(V)")
# creating the digital signal plot for comparison
plt.subplot(212)
plt.stem(n, digital)
plt.xlabel("Digital instants")
plt.ylabel("amplitude(V)")
pl.show()
