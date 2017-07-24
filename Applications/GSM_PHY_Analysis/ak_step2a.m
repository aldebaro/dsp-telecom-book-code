%Step 2a - find SCH
%After identifying the FB, the next task is to find the
%SCH burst that follows the FCCH. Because the oversampling
%factor is OSR=4, the number of samples from the start of the FCCH
%to the next in the multiframe (start of the SCH) is 156.25 x numTS x OSR
%= 5000 samples, where numTS=8 is the number of time slots
%and 156.25 is the number of symbol periods in each burst and
%corresponds to 577 microseconds. We have to use numTS above
%because this logic channel is observed in a specific time slot (TS)

%The assumed 51-multiframe structure (there are others) that
%is observed in a specific time slot (say TS0) of given frequency is
%FSBBBBCCCCFSCCCCCCCCFSCCCCCCCCFSCCCCCCCCFSCCCCCCCCI
%There is a FB (identified as F above) at every 10 bursts. Bursts are
%separated by 5000 samples, and 10 bursts = 50,000 samples
numOfSamplesIn8TimeSlots=5000; %156.25 x numTS x OSR=5000 samples, where numTS=8 and OSR=4

%% First alternative: all from first FB
disp('-------First alternative: all from first FB:')
increment = 10*numOfSamplesIn8TimeSlots; % number of samples
counter = 1; %count FCCHs starting from the first one
sch_start=fcch_start+numOfSamplesIn8TimeSlots; %from first FCCH
for n=sch_start:increment:length(r)
    disp(['FCCH counter = ' num2str(counter) '. SCH start according to:']);
    disp(['FB alone is at sample ' num2str(n)]);
    sch_startViaSCH=find_sch(r,n);
    disp(['SCCH itself (oversample=4) is at sample '...
        num2str(sch_startViaSCH)]);
    counter = counter + 1;
end

if counter-1 ~= length(fcchStartCandidates)
    counter
    length(fcchStartCandidates)    
    warning('Strange error in logic: counter ~= length(fcchStartCandidates)');
end
allSCHStarts=zeros(1,length(fcchStartCandidates)); %store SCH first samples
%% Second alternative: consider all detected FBs
disp('-------Second alternative: consider all detected FBs:')
for i=1:length(fcchStartCandidates)
    schStart=numOfSamplesIn8TimeSlots+oversampling*fcchStartCandidates(i); %fcchStartCandidates was obtained with oversampling = 1
    disp(['FCCH counter = ' num2str(i) '. SCH start according to:']);
    disp(['FB alone is at sample ' ...
        num2str(schStart)]);    
    allSCHStarts(i)=find_sch(r,schStart);
    if allSCHStarts(i)==-1 
        if i ~= length(fcchStartCandidates)
            i
            length(fcchStartCandidates)
            error('Error in logic: i ~= length(fcchStartCandidates)')
        end
        allSCHStarts(end)=[]; %delete this candidate
    else
        disp(['SCCH itself (oversample=4) is at sample '...
        num2str(allSCHStarts(i))]);
    end
end

if showPlots == 1
    n=fcch_start+numOfSamplesIn8TimeSlots; %recalculate for first segment
    [sync_burst_start,correlation,lag]=find_sch(r,n);
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