import numpy as np
from scipy.io import wavfile

# read the wav file
with open('myvoice.wav', 'rb') as fp:
    x = np.fromfile(fp, dtype=np.int16)

fp.close() # close the file
x = x[39:]  # remove the header

# read the wav file again for comparison
Fs, x2 = wavfile.read('myvoice.wav')
x2 = x2.astype(float)  # convert integer to double for easier manipulation

# check if they are identical
print(np.max(np.abs(x - x2)))  # result is 0, indicating they are identical