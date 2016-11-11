numberOfSymbols = 1000;   %number of symbols to be transmitted
Fc = 1000; %carrier frequency (Hz)
Fs = 8000; %sampling frequency (Hz)
df = 80;   %frequency resolution (see [Gardner, 1991])
dalpha = 20; %cyclic frequency resolution
L = 12;  %oversampling factor
b=4; %number of bits per symbol
pulseOption=2; %Choose a pulse option=1 or 2
%% Generate PAM signal
Rsym = Fs/L; %symbol rate (bauds)
M=2^b; %constellation order
symbolIndicesTx = floor(M*rand(1,numberOfSymbols)); %random symbols
constellation = pammod(0:M-1, M); %PAM constellation
symbols = pammod(symbolIndicesTx,M); %obtain PAM symbols from indices
%convert symbols into a waveform.
switch pulseOption
    case 1
        p = ones(1,L); %define a simple rectangular shaping pulse
    case 2
        r = 0.5; % Roll-off factor
        delay = 3; %group delay in symbles (at Rsym)
        p = ak_rcosine(Rsym,Fs,'fir/normal',r,delay);
end
p = p / (mean(p.^2)); %make sure pulse has unitary power
signal = zeros(1,numberOfSymbols*L); %pre-allocate space
signal(1:L:end) = symbols; %organize the symbols
signal = filter(p,1,signal); %pulse shaping filtering
wc=2*pi*Fc; %carrier frequency in rad/s
x = real(signal.*exp(1j*wc*(0:length(signal)-1)*(1/Fs)));
%%Cyclostationary analysis
[Sx, alphao, fo] = autofam(x,Fs,df,dalpha); %estimate the SCD
cyclicProfile = max(Sx,[],1); %estimate the cyclic profile
figure(1), plot(alphao,cyclicProfile/max(cyclicProfile));
if 0
    %compare with Matlab's commP25ssca (not available on Octave)
    [Sx2,alphao2,fo2] = commP25ssca(x',Fs,df,dalpha);
    cyclicProfile2 = max(Sx2,[],1); %estimate the cyclic profile
    hold on;
    plot(alphao2,cyclicProfile2/max(cyclicProfile2),'r');
    hold off
    figure(2); mesh (alphao, fo, Sx, 'EdgeColor', 'interp') ;
    figure(3); mesh (alphao2, fo2, Sx2, 'EdgeColor', 'interp') ;
end