import numpy as np
import wave

# Specify a WAV file_name
file_name = "myvoice.wav"

# Now we open the WAV file
with open(file_name, "rb") as audio_file:  # open for reading in binary
    frames = audio_file.read()

x = np.frombuffer(frames, dtype=np.int16)  # read all samples as signed 16-bits
x = x[22:]  # eliminate the 44-bytes header

# Get Raw samples
with wave.open(file_name, "r") as wf:
    x2 = np.frombuffer(wf.readframes(wf.getnframes()), dtype=np.int16)
    Fs = wf.getframerate()
    sample_width = wf.getsampwidth()  # Returns sample width in bytes.
    wmode = (
        wf.getnchannels()
    )  # Returns number of audio channels (1 for mono, 2 for stereo).

# Get the number of bits per sample
b = sample_width * 8  # Conversion to bits: 1 byte = 8 bits

x2 = x2.astype(np.double)  # convert integer to double for easier manipulation
result = np.array_equal(x, x2)
print(result)  # result is True, indicating vectors are identical
