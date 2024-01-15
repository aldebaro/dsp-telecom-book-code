import matplotlib.pyplot as plt
import numpy as np

Fs=8000 # sampling frequency (Hz)
Ts=1/Fs # sampling interval (seconds)
f0=400 # cosine frequency (Hz)
N=100 # number of desired samples
n=np.arange(N) # generate discrete-time abscissa, from n=0 to N-1
t=n*Ts # discretized continuous-time axis (sec.)
x=6* np.cos (2*np.pi*f0*t) # amplitude=6 V and frequency=f0 Hz
plt.stem(n,x) # plot discrete-time signal
plt.show() # plt requires this command to show the plots