'''
DTMF detection based on FFT.
This is a pedagogical tool. The implemented algorithm here is not as efficient,
as an implementation based on Goertzel algorithm [1,2].

Inspired on Ali Jamali Zavare's code: https://github.com/alijamaliz/DTMF-detector
I removed the dependency on PyAudio, which may require a C compiler.
And changed the algorithm to use peak picking.

[1] https://en.wikipedia.org/wiki/Goertzel_algorithm
[2] https://github.com/EliasOenal/multimon-ng/ and https://github.com/EliasOenal/multimon-ng/blob/master/demod_dtmf.c

October 10, 2020 - Aldebaro Klautau - www.lasse.ufpa.br/aldebaro
'''
from scipy.io import wavfile as wav
from scipy.fftpack import fft
from scipy.io import wavfile
#import wave
import numpy as np
import matplotlib.pyplot as plt
from scipy.signal import find_peaks

audio_file_name = 'dial2.wav' #input file in WAV format
should_plot = False #use True if want to see auxiliary plots or False otherwise
silence_duration = 80e-3 #in seconds, interval between two DTMF tones. It depends on the DTMF standard
window_duration =  50e-3 # in seconds, analysis windows. Suggestion: use as half of the DTMF duration
shift_duration = 10e-3 # in seconds, window shift
window_power_threshold = 6 # in dB, below this threshold from the maximum the window is considered silence
frequencies_power_threshold = 10 # in dB, below this threshold from the maximum the FFT value is considered zero
spectrum_resolution = 4 #in Hz, spectrum (FFT) resolution. The smaller this number, the larger the FFT size will be
frequency_error_tolerance = 5 #in Hz, tolerance to error when comparing estimated DTMF frequencies with nominal values

def nextpow2(x):
    return int(np.ceil(np.log2(np.abs(x))))

def extract_block(x, num_block, window_length, window_shift):
    first_sample = num_block * window_shift
    last_sample = first_sample + window_length
    return x[first_sample:last_sample]

def isNumberInArray(array, number, tolerance=5):
    for i in range(number - frequency_error_tolerance, number + frequency_error_tolerance):
        if i in array:
            return True
    return False

DTMF_TABLE = {
    '1': [1209, 697],
    '2': [1336, 697],
    '3': [1477, 697],
    'A': [1633, 697],

    '4': [1209, 770],
    '5': [1336, 770],
    '6': [1477, 770],
    'B': [1633, 770],

    '7': [1209, 852],
    '8': [1336, 852],
    '9': [1477, 852],
    'C': [1633, 852],

    '*': [1209, 941],
    '0': [1336, 941],
    '#': [1477, 941],
    'D': [1633, 941],
} 

# reading audio
Fs, signal = wav.read(audio_file_name) #change for your file name
Ts = 1/Fs #sampling interval = 1 / (sampling frequency)

window_length = round(window_duration / Ts)
window_shift = round(shift_duration / Ts)
silence_length = round(silence_duration / Ts)

#choose a strategy to determine the frequency (FFT) resolution
if False:
    num_fft = 2 ** nextpow2(window_length) #use FFT with size power of 2 for speed
    spectrum_resolution = Fs / num_fft #in Hz
else:
    num_fft = np.ceil(Fs/spectrum_resolution)
    num_fft = 2 ** nextpow2(num_fft) #use FFT with size power of 2 for speed
    spectrum_resolution = Fs / num_fft #in Hz

signal_length = len(signal)
#number of windows to analyze
num_windows = int( (signal_length - window_length) / (window_shift)) + 1
 
#detect the power in dB of each analysis window. The goal is to detect silence between DTMF tones
window_power = np.zeros((num_windows,), np.float)
for i in range(num_windows):
    signal_window = extract_block(signal, i, window_length, window_shift) #get one window for analysis
    energy = np.linalg.norm(signal_window) ** 2 #squared norm is the energy 
    average_power = energy / window_length #average power is normalized energy
    if average_power > 0: #avoid log of zero
        window_power[i] = 10.0 * np.log10(average_power) #convert from Watts to dB

if should_plot:
    #plot the signal and the power per window
    plt.subplot(311)
    plt.plot(signal)
    plt.ylabel('Signal amplitude')
    plt.subplot(312)
    plt.plot(window_power)
    plt.ylabel('Power per window')


max_power = np.max(window_power) #get maximum power over all windows
min_power = max_power - window_power_threshold #required minimum power in dB

#use binary array to distinguish DTMF (element = 1) or silence (element = 0)
#when finding consecutive runs of ones, choose a single representative: the one
#with maximum power. For instance, transform:
#0 1 1 1 0 0 0
#into:
#0 0 0 1 0 0 0    <= a single 1 represents the sequence of 3 1's above
#assuming the fourth window has more power than the second and third.
window_represents_DTMF = np.zeros((num_windows,), np.int) #initialize
interval_best_index = -1 #initialize, best index for the current "run" of ones
interval_max_power = -np.inf #initialize
for window_index in range(num_windows):
    if window_power[window_index] < min_power: 
        #it is a "silence", reset:
        interval_best_index = -1 
        interval_max_power = -np.inf
    else: #it is a window with enough power to be a potential DTMF 
        if window_power[window_index] > interval_max_power:
            #current power is larger than the best up to this moment
            if interval_best_index != -1:
                window_represents_DTMF[interval_best_index] = 0 #erase previous decision
            #update who is the "best":
            interval_max_power = window_power[window_index]
            interval_best_index = window_index
            window_represents_DTMF[interval_best_index] = 1


#filter very short silence segments such as 0 0 1 0 0, to turn it
#into 0 0 0 0 0 based on silence_duration in seconds, specified by the user,
#which was alredy converted to silence_length in samples
last_found_DTMF = -100000 #initialize with negative number
#each element of window_represents_DTMF represents a window, not
#a sample. Therefore, we need to define how many windows corresponds to the duration of silence:
silence_interval_in_windows = int(silence_length / window_shift)
if silence_interval_in_windows < 1:
    silence_interval_in_windows = 1 #should be at least 1
for window_index in range(num_windows):
    if window_represents_DTMF[window_index] == 1:
        #check how far is the current index 1 from previous index 1
        difference_in_indices = window_index - last_found_DTMF 
        if difference_in_indices  <= silence_interval_in_windows:
            window_represents_DTMF[window_index] = 0 #flip the current 1, to indicate silence now
        else:
            last_found_DTMF = window_index #update for next iteration

if should_plot:
    #plot the signal and the power per window
    plt.subplot(313)
    plt.plot(window_represents_DTMF)
    plt.ylabel('DTMF candidates')
    plt.show()


#At this stage we have a single window representing each DTMF tone.
#That is, if a tone of duration 200 ms was mapped to 4 windows of 50 ms each,
#we chose one among these four windows to represent the tone.
#
#The next stage is to recognize the frequencies using peak picking of the
#spectrum calculated for each window
for window_index in range(num_windows):
    if window_represents_DTMF[window_index] == 0:
        continue #skip the windows that are not representing a DTMF tone

    #get a single window of the signal to analyze
    signal_window = extract_block(signal, window_index, window_length, window_shift)

    #Calculate fourier trasform of this frame of the signal
    fourier_transform = np.fft.fft(signal_window, num_fft)
    spectrum_magnitude = np.abs(fourier_transform) / num_fft #normalize by the FFT length
    spectrum_magnitude_dB = 20 * np.log10(spectrum_magnitude) #convert to dB
    spectrum_magnitude_dB = spectrum_magnitude_dB[0:int(num_fft / 2)] #discard "negative" frequencies

    #Discard (make zero) all magnitudes above specified threshold
    max_frequency_amplitude = np.max(spectrum_magnitude_dB)
    zeroed_indices = spectrum_magnitude_dB < max_frequency_amplitude - frequencies_power_threshold
    spectrum_magnitude_dB[zeroed_indices] = 0

    #find the two strongest peaks
    peaks, _ = find_peaks(spectrum_magnitude_dB, height=0)  #only positive frequencies
    sortead_peak_index = np.argsort(spectrum_magnitude_dB[peaks])
    first_frequency_index = peaks[sortead_peak_index[-1]] #sort worked in ascending order, get last
    second_frequency_index = peaks[sortead_peak_index[-2]]

    #make sure first_frequency < second_frequency (this is not really necessary)
    if first_frequency_index > second_frequency_index:
        temp = first_frequency_index
        first_frequency_index = second_frequency_index
        second_frequency_index = temp

    #convert from index to frequency in Hertz
    first_frequency = first_frequency_index * spectrum_resolution
    second_frequency = second_frequency_index * spectrum_resolution

    if should_plot:
        plt.subplot(311)
        plt.plot(signal_window)
        plt.subplot(312)
        #generate frequency axis for plots
        f_axis = np.arange(0,len(spectrum_magnitude_dB))*spectrum_resolution 
        plt.plot(f_axis, spectrum_magnitude_dB)
        #indicate the location of the 2 peaks
        plt.plot(first_frequency, spectrum_magnitude_dB[first_frequency_index], "x")
        plt.plot(second_frequency, spectrum_magnitude_dB[second_frequency_index], "x")
        plt.show()

    #pack the two frequencies in a list
    detectedFrequencies = list()
    detectedFrequencies.append(int(round(second_frequency)))
    detectedFrequencies.append(int(round(first_frequency)))
    print('Detected frequencies:', detectedFrequencies)

    #check if the 2 detected frequencies compose a DTMF tone, and print it if the test is positive
    for char, frequency_pair in DTMF_TABLE.items():        
        if (isNumberInArray(detectedFrequencies, frequency_pair[0],tolerance=frequency_error_tolerance) and
            isNumberInArray(detectedFrequencies, frequency_pair[1],tolerance=frequency_error_tolerance)):
            print ('Decoded as ', char, '(nominal frequencies: ', frequency_pair,')')
            print('')
            break
            
