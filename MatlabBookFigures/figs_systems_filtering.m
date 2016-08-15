clf
x=[1:20,20:-1:1]; %input signal to be filtered, in Volts
[B,A]=butter(8,0.3); %IIR filter
h=impz(B,A,50); %truncate h[n] using 50 samples
%analyze filter
plotHandler = stem(0:length(h)-1,h);
xlabel('n')
ylabel('h[n]')
%makedatatip(plotHandler,7) %does not work with stem
writeEPS('butter_8_impulse_response')
clf
grpdelay(B,A); %plots the group delay of the filter
axis tight
writeEPS('butter_8_group_delay')
%analyze input
clf
stem(0:length(x)-1,x);
xlabel('n'), ylabel('x[n]')
axis([0 50 0 22])
writeEPS('butter_8_input_signal')
clf
X=fft(x)/length(x); %FFT of x, to be read in Volts
stem(0:length(X)-1,abs(X))
xlabel('k'), ylabel('|X[k]|')
writeEPS('butter_8_input_fft')
clf
%filtering
y=conv(x,h);  %convolution y=x*h
stem(0:length(x)-1,x);
hold on
stem(0:length(y)-1,y,'r','Marker','x');
xlabel('n')
legend('x[n]','y[n]')
axis tight
writeEPS('filtered_triangle','font12Only')
clf
y=filter(B,A,x); %now filter with filter
stem(0:length(x)-1,x);
hold on
stem(0:length(y)-1,y,'r','Marker','x');
xlabel('n')
legend('x[n]','y[n]')
axis([0 50 0 22])
writeEPS('filtered_triangle_with_filter','font12Only')


clf
clear all
x=[1:20,20:-1:1]; %input signal to be filtered, in Volts
[B,A]=butter(8,0.3); %IIR filter
h=impz(B,A,50); %truncate h[n] using 50 samples
y=conv(x,h);  %convolution y=x*h
y=transpose(y); %make x and y of same dimension
meanGroupDelay=5 %estimated "best" filter delay
y(1:meanGroupDelay)=[]; %compensate the filter delay
y(length(x)+1:end)=[]; %eliminate convolution tail
mse=mean( (x-y).^2 ) %calculate the mean squared error
SNR=10*log10(mean(x.^2)/mse) %estimate the signal to noise ratio
stem(0:length(x)-1,x); hold on
stem(0:length(y)-1,y,'r','Marker','x');
stem(0:length(y)-1,x-y,'k','Marker','+');
legend('x[n]','y[n]','x[n]-y[n]')
xlabel('n')
axis([0 40 0 22])
writeEPS('filtered_triangle_aligned','font12Only')

if 0 %example:
    [B,A]=butter(8,0.1); %IIR filter
    h=impz(B,A,50); %truncate h[n] using 50 samples
    y=conv(x,h);  %convolution y=x*h
    y=transpose(y); %make x and y of same dimension
    meanGroupDelay=16 %estimated "best" filter delay
    y(1:meanGroupDelay)=[]; %compensate the filter delay
    y(length(x)+1:end)=[]; %eliminate convolution tail
    mse=mean( (x-y).^2 ) %calculate the mean squared error
    SNR=10*log10(mean(x.^2)/mse) %estimate the signal to noise ratio
    stem(0:length(x)-1,x); hold on
    stem(0:length(y)-1,y,'r','Marker','x');
    stem(0:length(y)-1,x-y,'k','Marker','+');
    legend('x[n]','y[n]','x[n]-y[n]')
    xlabel('n')
    axis([0 40 0 22])
end

clf
clear all
x=[1:20,20:-1:1]; %input signal to be filtered, in Volts
[B,A]=butter(8,0.3); %IIR filter
N=5; %block length
numBlocks=floor(length(x)/N); %number of blocks
Zi=filtic(B,A,0); %initialize the filter memory with zero samples
y=zeros(size(x)); %pre-allocate space for the output
for i=0:numBlocks-1
    startSample = i*N + 1; %begin of current block 
    endSample = startSample+N -1; %end of current block
    xb=x(startSample:endSample); %extract current block
    %[yb,Zi]=filter(B,A,xb,Zi); %filter and update filter's memory
    [yb,Zi]=filter(B,A,xb); %filter not taking in account filter's memory
    y(startSample:endSample)=yb; %update vector y
end
stem(0:length(x)-1,x); hold on
stem(0:length(y)-1,y,'r','Marker','x');
legend('x[n]','y[n]')
xlabel('n')
axis([0 40 0 22])
writeEPS('filtered_triangle_without_memory','font12Only')