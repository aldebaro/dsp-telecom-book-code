The DigitalFilter project was developed by
the UFPA M. Sc. student Marcos Yuichi Takeda
in December, 2013. It implements a "universal
channel", which can be designed with Matlab.
The assumed sampling frequency is Fs=44100 Hz,
which can be modified by editing the source code
and recompiling. The used IDE was Netbeans.

1) Execute the code going to folder
Code\Java_Language\DigitalFilter\dist and typing 
(assuming you are using a command prompt)
java -jar DigitalFilter.jar

2) The GUI has two text areas to specify the numerator
B(z) (top area) and denominator A(z) (bottom area) of the
filter's system function H(z)=B(z)/A(z). 

You can design the filter using Matlab. For example, the command
[B,A]=fir1(10,0.5)
designs a lowpass filter with cutoff frequency at Fs/4. The vector B below can be pasted at the top text area:
0.0051   -0.0000   -0.0419    0.0000    0.2885    0.4968    0.2885    0.0000 -0.0419   -0.0000    0.0051
and A=1 into the bottom text area:
1

Now click "Change filter" and then the "Start" button.
The signal acquired by the sound board ADC will be filtered by H(z) and
the filter output sent to the sound board DAC.