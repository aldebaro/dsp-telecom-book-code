function frequency_offset_rads=calc_freq_offset(s, fcch_start, OSR, showPlots)

%SR = 270833; %sampling frequency
GUARD = 6 * OSR;
LENGTH = 148 * OSR - 2 * GUARD;

%segment signal
t = s(fcch_start+GUARD:fcch_start+GUARD+LENGTH);
L = length(t);
da = angle(t(1:L-1) .* conj(t(2:L))); %angle difference
v = mean(da);

frequency_offset_rads = -(pi/2/OSR) - v

if showPlots == 1
    clf
    %abscissa = GUARD:148-GUARD-1;
    abscissa = 1:length(da);
    plot(abscissa,-(pi/2)-da);
    hold on
    plot(abscissa,ones(size(abscissa))*frequency_offset_rads,'k:');
    xlabel('sample number n')
    ylabel('Angle difference (rad)')
    axis tight
end