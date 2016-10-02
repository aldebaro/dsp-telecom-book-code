switch channelNumber
    case 0 %ideal channel, h[n] = impulse
        B_channel = 1;
        A_channel = 1;
    case 1 %Butterworth IIR channel
        %To test new channels, one can design a Butterworth:
        %  Rp=3; %passband ripple
        %  Rs=10; %minimum stopband attenuation
        %find order N and cutoff frequency Wn
        %Example, assume an arbitrary 500 Hz of transition band:
        %  [N, Wn] = buttord([Fc1 Fc2]/(Fs/2), ...
        %     [Fc1-500 Fc2+500]/(Fs/2), Rp, Rs);
        %(buttord gives distinct results in Matlab versus Octave)
        N=2; Wn=[0.3 0.38]; %assign order and cutoff frequencies
        [B_channel,A_channel] = butter(N,Wn);
    case 2 %Elliptic IIR channel
        Rp=2; %passband IIR ripple
        Rs=40; %minimum stopband attenuation
        N=4; %pre-defined filter order
        [B_channel,A_channel]=ellip(N,Rp,Rs,...
            [Fc1 Fc2]/(Fs/2));
    case 3 %FIR channel
        Mc = 14; %channel dispersion
        if mod(Mc,2)==1 %is Mc an odd number?
            h=log([2:floor(Mc/2)+2])/log(floor(Mc/2)+2); 
            h=[h  fliplr(h)];
        else %Mc is an even number
            h=log([2:Mc/2+1])/log(Mc/2+1);
            h=[h 1 fliplr(h)];
        end
        B_channel = h.*cos(wc*(0:length(h)-1)); %modulate
        A_channel = 1; %it is a FIR, H(z) denominator is 1
end
