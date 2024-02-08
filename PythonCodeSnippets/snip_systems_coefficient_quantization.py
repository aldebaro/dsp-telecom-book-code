
from scipy.signal import ellipord, ellip, zpk2tf

Apass = 5 # maximum ripple at passband (dB)
Astop=40 # minimum attenuation at stopband (dB)
Fs=500 # sampling frequency
Wr1=10/(Fs/2)  # normalized frequencies (from 0 to 1):
Wp1=20/(Fs/2)  # frequencies in Hz are divided by ...
Wp2=120/(Fs/2) # the Nyquist frequency Fs/2
Wr2=140/(Fs/2)

N, Wp = ellipord([Wp1, Wp2], [Wr1, Wr2], Apass, Astop)# order,Wp
z, p, k = ellip(N, Apass, Astop, Wp, btype='band', output='zpk')# design digital filter
b, a = zpk2tf(z, p, k) # zero-pole to transfer function
print (b, a) # print coefficients