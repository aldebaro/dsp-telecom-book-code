import sounddevice as sd
import numpy as np
import matplotlib.pyplot as plt
from scipy.signal import welch
import time

Fs= 11025 #define sampling rate (Hz)
fc= 1500 #cosine frequency (Hz)
recordingDuration = 1 #duration of recording, in seconds

try:
    while True:
        r= sd.playrec(np.zeros(recordingDuration * Fs), Fs, channels=2) #recordingDuration*Fs = number of samples
        sd.wait()  # Wait until recording is finished
        sd.sleep(int(recordingDuration* 1000)) # Wait for the recordDuration in milliseconds
        print(r)
        
        #Graph in time domain
        time = np.arange(0, len(r)) / Fs
        plt.subplot(2, 1, 1)
        plt.cla()  #clears the chart before drawing the new one
        plt.plot(time, r)
        plt.xlabel('Time (s)')
        plt.ylabel('Amplitude')

        #Graph in the frequency domain
        f, Pxx = welch(r.flatten(), fs=Fs)
        plt.subplot(2, 1, 2)
        plt.cla()  
        plt.plot(f, Pxx)
        plt.xlabel('Frequency (Hz)')
        plt.ylabel('Power Spectral Density')

        plt.draw() #update the graph in the same figure
        plt.pause(0.1)

except KeyboardInterrupt: #press CTRL to end recording
    print("Finish Recording")
    