%periodic signals
clf
M=100, w=3*pi/17; %num of samples and angular freq. (rad)
n=0:M-1; %generate abscissa
xn=sin(w*n); stem(n,xn); %generate and plot a sinusoid
temp=[0 12 23 34];
n2=[temp 34+temp 68 80 91]
n3=0:34:M;
hold on
plot(n2,sin(w*n2),'xr','MarkerSize',16);
plot(n3,sin(w*n3),'or','MarkerSize',16);
xlabel('n'); ylabel('x[n]');
writeEPS('periodicsinusoid','font12Only');

clf
M=100, w=0.2; %%num of samples and angular freq. (rad)
n=0:M-1; %generate abscissa
xn=sin(w*n); stem(n,xn); %generate and plot a sinusoid
n2=[0,32,63,95];
hold on
plot(n2,sin(w*n2),'xr','MarkerSize',16);
xlabel('n'); ylabel('x[n]');
writeEPS('nonperiodicsinusoid','font12Only');
