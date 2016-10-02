%% Example of FFT of sinusoid with varying frequency. Illustrates leakage.
close all, clear all
A=6; %cosine amplitude
N=8; %%FFT length. It should be an even number
deltaW=2*pi/N; %FFT resolution in rad
fftFrequencyGrid=-pi:deltaW:pi-deltaW; %FFT frequencies in rad
Nlarge=N*10; %use a frequency grid with a multiple of N
w=-pi:2*pi/Nlarge:pi; %grid frequency: better resolution than FFT's grid
%% Create a sinc just for plotting, from -8*pi to 8*pi
wsinc=-8*pi:2*pi/Nlarge:8*pi-(2*pi/Nlarge); %frequency for sinc plots
if 0 %window is centered, with non-zero values from n=-M to M
    M=4; %total number of non-zero samples is 2*M+1
    mySinc = (A/2)*sin(((2*M+1)/2)*wsinc)./sin(wsinc/2);
else %window is not centered, with non-zero values from n=0 to N-1
    mySinc = (A/2)*sin((N/2)*wsinc)./sin(wsinc/2) .* ...
        exp(-j*((N-1)/2)*wsinc); %need to add linear phase component
end
if 0 %enable in case you want to see the sinc that will be used
    subplot(211); plot(wsinc/pi,abs(mySinc)), axis tight,
    title('Mag and phase of sinc');
    subplot(212); plot(wsinc/pi,angle(mySinc)), axis tight, pause
end
%% Show the result for a cosine with frequency wc
for k=1:length(w)  %loop over all frequencies in chosen grid
    clf, hold on; %clear figure and hold plots
    wc=w(k); %pick the cosine frequency
    %show the two sincs after convolving with the 2 impulses of the cosine
    %Use a trick and just shift the abscissa
    plot((wsinc-wc)/pi,abs(mySinc),'b') %sinc at the right
    plot((wsinc+wc)/pi,abs(mySinc),'y') %sinc at the left
    if wc==-pi || wc==pi || wc==0 %in these cases FFT shows just one tone
        stem(wc/pi,A*N,'b'); %one tone with amplitude A*N
        stem(wc/pi,A*N,'y'); %repeat it just to have the legend all right
        plot([-1,1],[1 1]*A*N,'--k');
    else %there are the positive and negative frequency tones
        stem(-wc/pi,A*N/2,'b'); stem(wc/pi,A*N/2,'y'); %amplitudes=A*N/2
        plot([-1,1],[1 1]*A*N/2,'--k');
    end
    %Now, plot the summation of the two sincs (get their combined effect)
    w2=-pi:2*pi/512:pi; %want only in the range from -pi to pi rad
    wr=w2-wc; wl=w2+wc; %left and right frequencies
    sumSincs = (A/2)*sin((N/2)*wr)./sin(wr/2).*exp(-j*((N-1)/2)*wr) + ...
        (A/2)*sin((N/2)*wl)./sin(wl/2).*exp(-j*((N-1)/2)*wl); %summation
    plot(w2/pi,abs(sumSincs),'g-') %plot only the magnitude
    x=A*cos(wc*(0:N-1)); %generate the cosine
    stem(fftFrequencyGrid/pi,fftshift(abs(fft(x))),'rx'); %show FFT result
    title(['Cosine frequency \Omega_c = ' num2str(wc) ' rad.' ...
        ' FFT is sampling the DTFT (sum of sincs)']);
    axis([-1 1 A*N*[-0 1]]) %clip the graph
    xlabel('Normalized frequency \Omega / \pi');
    ylabel('FFT  X[k] and DTFT   {X(e^{j\Omega})} magnitudes');    
    legend('sinc 1','sinc 2','tone 1','tone 2','reference','DTFT','FFT');
    pause
end