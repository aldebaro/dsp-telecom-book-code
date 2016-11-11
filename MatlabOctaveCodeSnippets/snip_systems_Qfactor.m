p1=-300+j*4000; p2=-300-j*4000; %pole and its conjugate
A=poly([p1 p2]); %convert it to a polynomial A(s)
omega_n = sqrt(A(3)); alpha = A(2)/2; %use definitions
Q = omega_n / (2*alpha) %calculate Q-factor

