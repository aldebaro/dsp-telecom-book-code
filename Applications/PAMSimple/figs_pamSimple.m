%show plots for script ak_pamSimple.m. First run ak_pamSimple
if 0 %show each signal segment
    numSymbols = 100;
    numFrames = floor(length(pamSymbols)/numSymbols);
    for i=0:numFrames-1
        beginIndex = 1 + i*numSymbols;
        endIndex = beginIndex + numSymbols - 1;
        x = beginIndex:endIndex;
        plot(x,zz(x),x,pamSymbols(x),'r');
        input('Press enter'); %pause
    end
end

freqz(B_channel,A_channel,[],Fs); title('Channel'), pause
freqz(A_channel,B_channel); title('Equalizer'), pause
grpdelay(B_channel,A_channel);
title('Channel group delay'), pause %seek group delay
zplane(B_channel,A_channel) 
title('Original channel poles and zeros'), pause

pwelch(s), title('Tx PSD'), pause
pwelch(r), title('Rx PSD'), pause
pwelch(r2), title('Rx complex envelope PSD'), pause
pwelch(xphat), title('Rx demodulated PSD'), pause
pwelch(p_rx), title('Rx filter'), pause

%skip delayInSamples
ak_plotEyeDiagram(2*delayInSamples,2*L,xphat)
title('Eye diagram')

numSymbols = 100;
numFrames = floor(length(r_hat)/numSymbols);
if 0 %show each signal segment
    for i=0:numFrames-1
        beginIndex = 1 + i*numSymbols;
        endIndex = beginIndex + numSymbols - 1;
        x = beginIndex:endIndex;
        plot(x,pamSymbols(x),x,r_hat(x),'r');        
        input('Press enter'); %pause does not work for certain old 
                                %versions of Octave for Windows
    end
end
clf
plot(real(pamSymbolsRx),imag(pamSymbolsRx),'or',...
    real(pamSymbols),imag(pamSymbols),'x');
legend('received','transmitted');