N=100; x=randn(1,N); %WGN with zero mean and unit variance
y=filter(4,[1 0.5 0.98],x); %realization of an AR(2) process
Py=mean(y.^2) %signal power
[A,Perror]=lpc(y,2) %estimate filter via LPC
h=impz(1,A,500); %impulse response of 1/A(z)
Eh=sum(h.^2) %impulse response energy
Py - (Perror*Eh) %compare Py with Perror*Eh