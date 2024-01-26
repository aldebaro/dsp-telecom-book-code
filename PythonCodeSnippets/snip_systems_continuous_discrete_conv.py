import numpy as np
from matplotlib import pyplot as plt

T0 = 0.2  # pulse "duty cycle" (interval with non-zero amplitude): 0.2 s
Ts = 2e-3  # sampling interval: 2 ms
N = T0/Ts  # number of samples to represent the pulse "duty cycle"
A = 4  # pulse amplitude: 4 Volts
pulse = A * np.hstack([np.zeros(int(N)),
                       np.ones(int(N)), np.zeros(int(4*N))])  # pulse
triangle = Ts*np.convolve(pulse, pulse)  # (approx.) continuous convolution
print(f'Convolution peak at {T0} is {(A**2)*T0}')
plt.subplots_adjust(hspace=0.4)
myaxis = [-0.2, 0.6, -1, 5]  # show this interval
plt.subplot(2, 1, 1)
t = Ts * (np.arange(0, len(pulse))-N+1)  # time axis, create "negative" time(
plt.plot(t, pulse, color='g')
plt.ylabel('p(t)')
plt.title('Pulse')
plt.subplot(212)
t = Ts*(np.arange(0, len(triangle))-2*N)
h = plt.plot(t, triangle)
plt.ylabel('p(t)*p(t)')
plt.annotate(
    'peak',
    xy=(0.2, 3.2),
    xytext=(0.5, 2),
    arrowprops=dict(arrowstyle="->", facecolor='black'),
    horizontalalignment='center', verticalalignment='bottom')
plt.xlabel('time (s)')
plt.title('Convolution')
plt.show()
