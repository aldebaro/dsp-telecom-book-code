fs=22050; %sampling frequency
r = audiorecorder(fs, 16, 1);%create audiorecorder object
recordblocking(r,5);%record 5 s and store inside object r
y = getaudiodata(r,'int16'); %retrieve samples as int16
x = double(y); %convert from int16 to double
soundsc(x,fs); %play at the sampling frequency
soundsc(x,round(fs/2));%play at half of the sampling freq.
soundsc(x,2*fs); %play at twice the sampling frequency
w=x(1:2:end); %keep only half of the samples
soundsc(w,fs); %play at the original sampling frequency
z=zeros(2*length(x),1); %vector with twice the size of x
z(1:2:end)=x;%copy x into odd elements of z (even are 0)
soundsc(z,fs); %play at the original sampling frequency

