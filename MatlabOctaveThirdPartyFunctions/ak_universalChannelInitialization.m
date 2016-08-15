playDeviceID=10; %the device ID, choose it using select_play...
recDeviceID=10; %the device ID, choose it using select_rec...
playChan=1; %number of channels used for playback
recChan=1; %number of channels used for recording
Fs=44100; %sampling frequency
debug=1; %use 1 to show the number of skipped samples or 0 otherwise
%other definitions follow below:  ...

% Increase these values to ensure output stability (ie resilience to
% glitches) at the expense of a longer latency
pageSize = 2048;    %size of each page processed
pageBufCount = 5;   %number of pages of buffering

%When true, the processor is used much more heavily (ie always at 
%maximum), but the chance of glitches is reduced without increasing
%latency
runMaxSpeed = false; 

%Test if current initialisation is ok
if(playrec('isInitialised'))
    if(playrec('getSampleRate')~=Fs)
        fprintf('Changing playrec sample rate from %d to %d\n', ...
            playrec('getSampleRate'), Fs);
        playrec('reset');
    elseif(playrec('getPlayDevice')~=playDeviceID)
        fprintf('Changing playrec play device from %d to %d\n', ...
            playrec('getPlayDevice'), playDeviceID);
        playrec('reset');
    elseif(playrec('getRecDevice')~=recDeviceID)
        fprintf('Changing playrec record device from %d to %d\n', ...
            playrec('getRecDevice'), recDeviceID);
        playrec('reset');
    elseif(playrec('getPlayMaxChannel')<playChan)
        fprintf('Resetting playrec to configure device to use more output channels\n');
        playrec('reset');
    elseif(playrec('getRecMaxChannel')<recChan)
        fprintf('Resetting playrec to configure device to use more input channels\n');
        playrec('reset');
    end
end

%Initialise if not initialised
if(~playrec('isInitialised'))
    fprintf('Initialising playrec to use sample rate: %d, playDeviceID: %d and recDeviceID: %d\n', Fs, playDeviceID, recDeviceID);
    playrec('init', Fs, playDeviceID, recDeviceID, playChan, recChan);
    
    % This slight delay is included because if a dialog box pops up during
    % initialisation (eg MOTU telling you there are no MOTU devices
    % attached) then without the delay Ctrl+C to stop playback sometimes
    % doesn't work.
    pause(0.1);
end
    
if(~playrec('isInitialised'))
    error ('Unable to initialise playrec correctly');
elseif(playrec('getRecMaxChannel')<playChan)
    error ('Selected device does not support %d output channels\n', playChan);
end
playrec('delPage'); %Clear all previous pages
playSampleBuffer = zeros(pageSize, 1); %Define buffer for playback
pageNumList = repmat(-1, [1 pageBufCount]); %Create vector to act as FIFO for page numbers
playrec('resetSkippedSampleCount'); %reset counter
