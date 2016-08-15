function ak_plotFrequencyResponseAndMask(H,w,Apass,Astop,Wp,Wr,type)
clf;
subplot(211); 
semilogx(w,20*log10(abs(H)));
ylabel('20 log_{10} |H(\omega)| (dB)')
grid
subplot(212); 
semilogx(w,unwrap(angle(H)));
ylabel('Unwrapped phase (rad)')
xlabel('frequency (rad/s)')
grid

if nargin > 2 %user specified the magnitude mask
    subplot(211);
    hold on
    if strcmp(type,'lowpass')
        plot([min(w) Wp],-[Apass Apass],'r');
        plot([Wr max(w)],-[Astop Astop],'r');
    elseif strcmp(type,'highpass')
        plot([min(w) Wr],-[Astop Astop],'r');
        plot([Wp max(w)],-[Apass Apass],'r');
    elseif strcmp(type,'bandpass')
        plot([min(w) Wr(1)],-[Astop Astop],'r');
        plot([Wp(1) Wp(2)],-[Apass Apass],'r');
        plot([Wr(2) max(w)],-[Astop Astop],'r');
    end
end