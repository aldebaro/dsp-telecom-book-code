import numpy as np

N = 5  # number of FFT points
M = 2  # maximum number of autocorrelation lags
BW = 1  # BW in normalized frequency (digital Hertz)
x = np.array([6, 0, 0, 0, 0])  # impulse signal truncated in N samples

# MS spectrum: all values are 2.25 Watts
Sms = np.abs(np.fft.fft(x) / N) ** 2

# Periodogram
Sk = np.abs(np.fft.fft(x, n=len(x))) ** 2

# Estimating autocorrelation
R = np.correlate(x, x, mode='full') / len(x)
lags = np.arange(-M, M + 1)

Sxcorr = np.abs(np.fft.fft(R))# PSD via autocorrelation


Power = np.sum(Sms)# Power obtained from MS spectrum


Power2 = (BW / N) * np.sum(Sk)# Power from periodogram


Power3 = (BW / N) * np.sum(Sxcorr)# Power from periodogram via xcorr


print("MS Spectrum:", Sms)
print("Periodogram:", Sk)
print("Autocorrelation:", R)
print("Power (MS Spectrum):", Power)
print("Power (Periodogram):", Power2)
print("Power (Periodogram via xcorr):", Power3)
