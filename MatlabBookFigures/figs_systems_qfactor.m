close all
clf
p1=-300+j*4000; p2=-300-j*4000; %define a pole and its complex conjugate
A=poly([p1 p2]); %convert it to a polynomial A(s)
Q=sqrt(A(3)) / A(2) %find the Q-factor of this pair of poles
Q=abs(p1) / (2*(-real(p1))) %alternative calculation of Q

BW=4000/Q;
w1=3678;
w2=w1+BW;
Q2=4000/(w2-w1)

w = sort([w1 w2 4000 linspace(2000, 8000, 200)]);
ndxW1 = find(w==w1);
ndxW2 = find(w==w2);
ndxW3 = find(w==4000);
[H,w]=freqs(A(3),A,w);
subplot(211)
hdBplot = plot(w,20*log10(abs(H)))
ylabel('|H(\omega)| (dB)');
%xlabel('frequency (rad/s)');
%makedatatip(hdBplot,[ndxW1 ndxW2 ndxW3])
grid
makedatatip(hdBplot,[ndxW2])

[H2,w]=freqs(A(3),A,[0 4000]), 20*log10(abs(H2))

%############# second plot
subplot(212)
%hphasePlot = plot(w,angle(H))
%ylabel('Phase of H(\omega) (rad)');
%xlabel('frequency (rad/s)');
%grid

p1=-3+j*4000; p2=-3-j*4000; %define a pole and its complex conjugate
Q=abs(p1) / (2*(-real(p1))) %alternative calculation of Q
A=poly([p1 p2]); %convert it to a polynomial A(s)
BW=4000/Q;
w1=4000 - BW/2
w2=4000 + BW/2
w = sort([w1 w2 4000 linspace(2000, 8000, 200)]);
ndxW2 = find(w==w2);
[H,w]=freqs(A(3),A,w);
hdBplot2 = plot(w,20*log10(abs(H)))
ylabel('|H(\omega)| (dB)');
xlabel('frequency (rad/s)');
grid
makedatatip(hdBplot2,[ndxW2])

[H3,w]=freqs(A(3),A,[0 4000]), 20*log10(abs(H3))

writeEPS('qfactor_resonator');

