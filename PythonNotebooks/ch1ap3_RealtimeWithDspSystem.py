import numpy as np
import pyaudio
from scipy import signal, fftpack
import matplotlib.pyplot as plt

Fs = 8000  # Sampling rate (Hz)
exampleNumber = 1

p = pyaudio.PyAudio()
microphone = p.open(format=pyaudio.paInt16, channels=1, rate=Fs, input=True)
microphone.start_stream()

if exampleNumber == 1:
    # Configure the spectrum analyzer
    specAnalyzer = plt.figure()
    ax = specAnalyzer.add_subplot(1, 1, 1)
    ax.set_xlabel("Frequency (Hz)")
    ax.set_ylabel("Magnitude")
    ax.set_title("Audio Spectrum")

else:
    # Configure the digital filter
    B, A = signal.butter(4, 0.05)  # 4th-order Butterworth filter
    filterMemory = np.zeros(max(len(B), len(A)) - 1)
    speaker = p.open(format=pyaudio.paInt16, channels=1, rate=Fs, output=True)
    speaker.start_stream()

print("Infinite loop, stop with CTRL + C ...")
try:
    while True:
        audio = microphone.read(Fs)  # Record audio

        if exampleNumber == 1:
            # Perform spectrum analysis
            audio = (
                np.frombuffer(audio, dtype=np.int16) / 32768.0
            )  # Normalize the audio
            freqs = fftpack.fftfreq(len(audio), 1 / Fs)
            fft_result = fftpack.fft(audio)
            magnitude = np.abs(fft_result)

            ax.clear()
            ax.plot(freqs, magnitude)
            # ax.set_xlim(0, Fs / 2)  # Limit the graph to positive frequencies
            plt.pause(0.01)

        else:
            # Perform digital filtering
            audio = (
                np.frombuffer(audio, dtype=np.int16) / 32768.0
            )  # Normalize the audio
            if not len(filterMemory) == 0:
                filterMemory = np.zeros(max(len(B), len(A)) - 1)
            output, filterMemory = signal.lfilter(B, A, audio, zi=filterMemory)
            speaker.write(
                (output * 32768).astype(np.int16)
            )  # Send the filtered audio to the speaker

except KeyboardInterrupt:
    print("Stopping...")
finally:
    microphone.stop_stream()
    microphone.close()
    if exampleNumber == 2:
        speaker.stop_stream()
        speaker.close()
    p.terminate()
