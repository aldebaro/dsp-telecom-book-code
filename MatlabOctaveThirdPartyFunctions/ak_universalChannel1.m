%Example of LTI channel implemented as H(z)=B(z)/A(z), below
ak_universalChannelInitialization %initialize sound card acquisition
%(script above defines Fs and sound recording/playback parameters)
[B,A]=butter(30,0.5); %design some filter to play the role of channel
[ans, memory] = filter(B,A,zeros(1,100)); %initialize filter's memory
while true %script runs until interrupted (by CTRL + C, for example)
    %-1 is to record the same number of samples in playSampleBuffer
    newPageNumber = playrec('playrec', playSampleBuffer, playChan,...
        -1, recChan);
    pageNumList = [pageNumList newPageNumber]; %add to end of list
    if(runMaxSpeed) %consumes more CPU
        while(playrec('isFinished', pageNumList(1)) == 0)
        end
    else %less CPU-demanding
        playrec('block', pageNumList(1)); %blocks until recording
    end
    recSamples = playrec('getRec', pageNumList(1)); %get rec. samples
    playrec('delPage', pageNumList(1)); %delete the current page
    pageNumList = pageNumList(2:end); %exclude page number from list
    if (~isempty(recSamples)) %DSP code section
        %Your DSP code must go here, inside the 'if' instruction. The
        %recSamples and playSampleBuffer store the input and output
        %channel samples, respectively.
        [playSampleBuffer, memory] = filter(B,A,recSamples,memory);
    end        
    if debug == 1 %send to stdout (if outside the loop, it would not
        fprintf('%d samples skipped!\n', ... %print due to CTRL+C)
            playrec('getSkippedSampleCount'));
    end
end
playrec('delPage'); %clean exit, but not executed due to user CTRL+C