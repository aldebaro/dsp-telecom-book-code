r=audiorecorder(11025,16,1); %create audiorecorder object
recordblocking(r,5); %record 5 seconds and store inside r
play(r) %playback the sound
y = getaudiodata(r, 'int16'); %extract samples as int16
plot(y); %show the graph

