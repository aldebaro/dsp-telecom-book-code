f=[0 0.25 0.3 0.55 0.6 0.85 0.9 1]; %frequencies
Amp=[1 1 0 0 1 1 0 0]; %amplitudes
M=10; %filter order
Bsystem=firls(M,f,Amp); %design FIR with LS algorithm
Asystem = 1; %the FIR filter has denominator equal to 1
h=Bsystem; %impulse response of a FIR coincides with B(z)
... %here goes the code of previous example, up to P=5
P=20;%we do not know correct order of A(z). Use high value
... %code of previous example continues from here

