import numpy as np
import matplotlib.pyplot as plt
import sincRec_fuction as sR

## Define variables
Ts=0.1 #sampling interval (in seconds)
Fs=1/Ts #sampling frequency (5 Hz)
oversampling_factor = 200 #oversampling factor
textra = 0.5 #one extra time (2 seconds) for visualizing sincs
graph_overlay = False #allows you to plot overlapping graphs
sinc_support = 0.2 #support of the sinc in seconds
n= np.arange(-8,12+1)#segment of samples of interest
## Generate signal xn sampled at Fs
t=n*Ts #discrete-time axis in seconds
xn = np.sinc(t/sinc_support) - 3*np.sinc((t-0.2)/sinc_support) + \
    3*np.sinc((t-0.4)/sinc_support) #define the sampled signal
## Generate oversampled version of xn
oversampled_Ts = Ts/oversampling_factor #new value of Ts
oversampled_n = np.arange(n[0]*oversampling_factor,n[-1]*oversampling_factor + 1)
oversampled_t = oversampled_n*oversampled_Ts #time in seconds
oversampled_xn = np.sinc(oversampled_t/sinc_support) - \
                3*np.sinc((oversampled_t-0.2)/sinc_support) + \
                3*np.sinc((oversampled_t-0.4)/sinc_support) #oversampled signal
## Reconstruct signal from samples stored at xn and compare with 
## the "ground truth" oversampled_xn

a=sR.ak_sinc_reconstruction(n,xn,Ts,oversampled_n,oversampled_xn,textra, graph_overlay) #Store all output
