function ak_plotNyquistPulse(p,L)
% function ak_plotNyquistPulse(p,L)
%Inputs: p is the pulse (typically a zero ISI pulse)
%        L is the oversampling factor

clf
N=2^16; %number of FFT points. Use large to approximate...
P=fft(p,N); %the DTFT using the FFT
dw=2*pi/N; %frequency interval em rads
w=0:dw:2*pi-dw; %frequency axis

subplot(311)
plot(w,abs(P))
title('Magnitude of the shaping pulse DTFT');
ylabel('|P(e^{j \Omega})|')
keepFrom0To2Pi

w0=2*pi/L;
%expand the frequency range
subplot(312)
neww = [w-2*pi w w+2*pi];
newP = [P P P];
hold on
myColors = get(gca,'ColorOrder');
givenFreq = pi/4;
for k=0:L-1
    myColor = myColors(mod(k+1,7)+1,:);
    startingFreq = k*w0;
    h=plot(neww+k*w0,abs(newP)/L,'Color',myColor);
    %ndx = find(neww >= givenFreq-startingFreq);
    %makedatatip(h,[ndx(1), ndx(2)]); pause
end
title('Magnitude of the pulse replicas');
keepFrom0To2Pi

subplot(313)
sumP = zeros(1,N);
hold off
for k=0:L-1
    startingFreq = k*w0;
    indices = find(neww >= startingFreq);
    firstIndex = indices(1);
    %neww(firstIndex)
    %linearPhase = exp(-j*startingFreq*N0)
    %sumP = sumP + newP(firstIndex:firstIndex+N-1) * linearPhase;
    sumP = sumP + newP(firstIndex:firstIndex+N-1);
    %sumP = sumP + abs(newP(firstIndex:firstIndex+N-1));
    %plot(w,abs(sumP)/L), pause
end
%sumP = sumP .* exp(-j*(2*pi*N0/N)*(0:length(sumP)-1));
plot(w,abs(sumP)/L)
title('Magnitude of the pulse replicas summation');
ylabel('|P_s(e^{j \Omega})|')
keepFrom0To2Pi
xlabel('\Omega (rad)');
end

function keepFrom0To2Pi
myaxis=axis;
myaxis(1)=0;
myaxis(2)=2*pi;
axis(myaxis)
end
