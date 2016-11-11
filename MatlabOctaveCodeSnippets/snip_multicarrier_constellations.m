%Script constellations.m
%Normalization of transmit constellations
clear all; close all;

%1) Design Gray-coded constellations
M = 4;
x = [0:M-1];
cons4 = pammod(x,M,[],'gray');

M = 2^3;
x = [0:M-1];
cons8 = qammod(x,M,[],'gray');

%2) Normalize to have power equal to one
%(note that steps 2 and 3 could be collapsed)
cons4 = cons4 / sqrt(mean(abs(cons4).^2));
cons8 = cons8 / sqrt(mean(abs(cons8).^2));

%3) Find new scale factors and constellations
%original average powers:
originalAveragePowers = [mean(abs(cons4).^2) mean(abs(cons8).^2) ...
    mean(abs(cons4).^2)]
targetPower = [4, 10, 20]
scaleFactors = sqrt(targetPower ./ originalAveragePowers )

cons_tone0 = scaleFactors(1) * cons4;
cons_tone1 = scaleFactors(2) * cons8;
cons_tone2 = scaleFactors(3) * cons4;

%4) Plot the Gray-coded constellations
M=4;
y = cons_tone0; %4-QAM
scatterplot(y,1,0,'b.'); % Dots for points.
% Include text annotations that number the points in binary.
hold on; % Make sure the annotations go in the same figure.
annot = dec2bin([0:length(y)-1],log2(M));
text(real(y)+0.4,imag(y),annot);
axis(4*[-1 1 -1 1]);
title('Constellation for Gray-Coded 4-QAM in tone 0');
hold off;

M=8;
y = cons_tone1; %8-QAM
scatterplot(y,1,0,'b.'); % Dots for points.
% Include text annotations that number the points in binary.
hold on; % Make sure the annotations go in the same figure.
annot = dec2bin([0:length(y)-1],log2(M));
text(real(y)+0.4,imag(y),annot);
axis(8*[-1 1 -1 1]);
title('Constellation for Gray-Coded 8-QAM  in tone 1');
hold off;

M=4;
y = cons_tone2; %4-QAM
scatterplot(y,1,0,'b.'); % Dots for points.
% Include text annotations that number the points in binary.
hold on; % Make sure the annotations go in the same figure.
annot = dec2bin([0:length(y)-1],log2(M));
text(real(y)+0.4,imag(y),annot);
axis(10*[-1 1 -1 1]);
title('Constellation for Gray-Coded 4-QAM in tone 2');
hold off;

%5) For the bits B=[1011001] and using the data cursor in Matlab, the
%indices are:
index0 = 3; %10
index1 = 7; %110
index2 = 2; %01
%IFFT input, forcing Hermitian symmetry:
X = [cons_tone0(index0);
    cons_tone1(index1);
    cons_tone2(index2);
    conj(cons_tone1(index1))]
%unitary FFT:
[A, Ai]=ak_fftmtx(4,1);
x = Ai * X;
%clean up numerical errors: IFFT output
x = real(x)

%6) Add cyclic prefix and estimate power
if 1
    %with CP
    x_cp = [x(3); x(4); x]
else
    %without CP
    x_cp = x
end
%in this segment the total energy can be estimated using the integral
%of the instantaneous power assuming rectangles with amplitude 1 and base
%Ts, where Ts is the sampling frequency
T = 2e-3; %2 ms
Ts = T/length(x_cp);
totalEnergy = Ts * sum(x_cp .^ 2);
totalTime = T; %
power = totalEnergy / totalTime
%you could also note that
power = mean(x_cp .^ 2)

%7) Change the if above to false (that is, to 0) and run again.
%Note that Parseval will hold only with there is no cyclic prefix
powerInFrequency = mean(abs(X) .^ 2)

