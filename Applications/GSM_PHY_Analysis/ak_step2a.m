%Step 2a - find SCH
%After identifying the FB, the next task is to find the
%SCH burst that follows the FCCH. Because the oversampling
%factor is OSR=4, the number of samples from the FCHH 
%beginning to the start of the SCH is 156.25 x numTS x OSR
%= 5000 samples, where numTS=8 is the number of time slots

%The assumed 51-multiframe structure (there are others) is
%FSBBBBCCCCFSCCCCCCCCFSCCCCCCCCFSCCCCCCCCFSCCCCCCCCI
%There is a FB (or F) at every 10 bursts. Bursts are 
%separated by 5000 samples, and 10 bursts = 50,000 samples
increment = 50000; %samples
counter = 1;
for n=(fcch_start+5000):increment:length(r)
    n
    disp(['Counter = ' num2str(counter)]);
    disp('FHCC start according to FHCC alone:');
    disp(['Sample ' num2str(n)]);
    fch_startViaSCH=find_sch(r,n,n+599);
    disp('FHCC start tuned by the SCCH (oversample=4):');
    disp(['Sample ' num2str(fch_startViaSCH)]);
    counter = counter + 1;
end

if showPlots == 1
    n=fcch_start+5000; %recalculate for first segment
    [sync_burst_start,correlation,lag]=find_sch(r,n,n+599);
    a = r(n:n+610);
    clf
    subplot(3,1,1);
    L = length(a);
    ea = angle(a(1:L-1) .* conj(a(2:L)));
    fa = cumsum(ea);
    plot(fa);
    title('Received sequence');
    axis tight
    myAxis = axis;
    ylabel('Phase (rad)');
    
    subplot(3,1,2);
    L = length(syncSymbols);
    da=angle(syncSymbols(1:L-1).*conj(syncSymbols(2:L)));
    sa = cumsum(da);
    plot(sa);
    title('Pre-defined synchronism sequence');
    myAxis2 = axis;
    %make it have the same abscissa as previous plot
    axis([myAxis(1) myAxis(2) myAxis2(3) myAxis2(4)])
    xlabel('sample (n)')
	ylabel('Phase (rad)');

    subplot(3,1,3);
    plot(lag, abs(correlation));
    xlabel('lag')
    ylabel('Cross-correlation');
    axis tight
end