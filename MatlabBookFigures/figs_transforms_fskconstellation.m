%binary FSK constellation
clf
plot(1,0,'o','markersize',14);
hold on
plot(0,1,'o','markersize',14); 
xlabel('coefficient of frequency f_0')
ylabel('coefficient of frequency f_1')
axis([-0.1 1.2 -0.1 1.2]);
grid;
writeEPS('binaryfsk_constellation');

%show modulated waveform
clf
bitStream = [1, 0, 0, 1, 0, 1];
S=32;       %number of samples per symbol
N_0=8;   		%period of sinusoid corresponding to bit 0
N_1=4;   		%period of sinusoid corresponding to bit 1
n=(0:S-1)'; %time index
A=[cos(2*pi/N_0*n) cos(2*pi/N_1*n)]*sqrt(2/S); %inverse matrix
x=[]; %modulated waveform
for i=1:length(bitStream)
    if bitStream(i) == 0
        x=[x;A(:,1)];
    else
        x=[x;A(:,2)];
    end
end
plot(0:length(x)-1,x)
xlabel('n (samples)');
grid
set(gca,'XTick',[0:32:200])
set(gca,'YTick',[])
writeEPS('binaryfsk_waveform');

%3-ary FSK constellation
clf
plot3(1,0,0,'o','markersize',14);
hold on
plot3(0,1,0,'o','markersize',14); 
plot3(0,0,1,'o','markersize',14);
xlabel('coefficient of frequency f_0')
ylabel('coefficient of frequency f_1')
zlabel('coefficient of frequency f_2')
axis([-0.1 1 -0.1 1 -0.1 1]);
grid;
view([-26 -38]);
writeEPS('fsk_constellation');
