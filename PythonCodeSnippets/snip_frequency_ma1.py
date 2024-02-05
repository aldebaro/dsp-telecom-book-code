import numpy as np
import matplotlib.pyplot as plt
from scipy.signal import lfilter
from lasse.util.ak_functions import ak_psd

B = np.array([1+3j, -0.8-2j]) #MA highpass filter with complex coefficients
#B = np.array([1, 0.8]) #MA lowpass filter with real coefficients
x = np.random.randn(10000) #generate white noise
Px = np.mean(np.abs(x)**2) #input signal power
Fs = 1 #Fs = BW = 1 Dhz to obtain discrete-time PSD
y = lfilter(B,1,x) #generate MA(1) process
Syy,f = ak_psd(y,Fs) #find PSD via Welch's method
plt.plot(2*np.pi*f,Syy)#plot estimated PSD in dBm/Dhz
Hmag2 = (B[0]*np.conj(B[1])*np.exp(1j*2*np.pi*f))+np.sum(np.abs(B)**2)+ \
    (np.conj(B[0])*B[1]*np.exp(-1j*2*np.pi*f))
Hmag2 = np.real(Hmag2)
plt.plot(2*np.pi*f,10*np.log10(Hmag2/1e-3),'r')#theoretical, in dBm/Dhz
plt.xlabel('$\Omega$ (rad)')
plt.ylabel('$S(e^{j\Omega})$  dBm/Dhz')
plt.tight_layout()
plt.show()