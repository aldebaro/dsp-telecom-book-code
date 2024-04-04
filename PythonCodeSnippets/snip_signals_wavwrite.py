import numpy as np
from scipy.io import wavfile
import wave


# Writing settings
def write_wav(file_path, sample_rate, data):
    with wave.open(file_path, "w") as wf:
        wf.setnchannels(1)  # Setting for one channel (mono)
        wf.setsampwidth(2)  # Setting to 16 bits (2 bytes)
        wf.setframerate(sample_rate)  # Sample Rate Setting
        wf.writeframes(np.array(data, dtype=np.int16).tobytes())


file_name = "somename.wav"

y = np.array([14, 50, 3276, -32768, 14, 0], dtype=np.int16)  # example, as column vector
write_wav(file_name, 11025, y)


"""
Alternatively, one can use 
the wavfile.write(<file_name>, <sample_rate>,<data>) module

wavfile.write(path, 11025, y)
"""

with wave.open(file_name) as wf:
    z = np.frombuffer(wf.readframes(wf.getnframes()), dtype=np.int16)

result = np.array_equal(y, z)
print(result)  # should return true

