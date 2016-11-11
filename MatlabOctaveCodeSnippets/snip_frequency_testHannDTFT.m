function snip_frequency_testHannDTFT
N=9; %number of window samples
[dtftHann,w]=freqz(hann(N)); %get values of the DTFT as reference
dtftHann2=0.5*rectWinDTFT(w,N)- 0.25*rectWinDTFT(w+(2*pi/(N-1)),N)...
    -0.25*rectWinDTFT(w-(2*pi/(N-1)),N); %DTFT using expression
plot(w,real(dtftHann-dtftHann2),w,imag(dtftHann-dtftHann2)) %error
end
function D=rectWinDTFT(w,N) %get DTFT of rectangular window
D=sin(0.5*N*w)./sin(0.5*w).*exp(-j*0.5*w*(N-1));
end