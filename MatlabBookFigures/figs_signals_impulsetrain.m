%generate example of y[n]=x[-n]
clf
x=[3 0 4 0 5];
y=fliplr(x);
n1=0:4;
n2=-4:0;
subplot(211); stem(n1,x); title('x[n]'); axis([-5 5 -1 6]); ak_add3dots
subplot(212); stem(n2,y); title('y[n]'); axis([-5 5 -1 6]); ak_add3dots
xlabel('n');
writeEPS('timereversal');

%generate impulse train
clf
Ts=125e-6;
N=6;
t=-N*Ts:Ts:N*Ts;
x=ones(1,length(t));
ak_impulseplot(x,t,[]);
axis([-8e-4 8e-4 0 1.5])
ak_add3dots
writeEPS('impulsetrain');

%some random signal
clf
randn('state',0);
y=randn(1,50);
b=ones(1,20);
y=filter(b,1,y);
%y=filter(b,1,y); %filter again to smooth more
t=0:Ts:(length(y)-1)*Ts;
ak_timeplot(t,y,'Color','k');
ak_add3dots
grid
writeEPS('analogsignal');

%digital version of the analog signal
n=0:length(y)-1;
stem(n,round(y)) %use round to quantize with quantization step = 1
grid
xlabel('Sample (n)')
ylabel('Amplitude')
ak_add3dots
writeEPS('digitalsignal','font12Only');

%sampled signal
clf
ak_impulseplot(y,t,[]);
hold on
ak_timeplot(t,y,'Color','k','LineStyle',':');
ak_add3dots
writeEPS('sampledanalog','font12Only');

%discrete-time signal
clf
stem(n,y) %do NOT use round
grid
xlabel('Sample (n)')
ylabel('Amplitude')
ak_add3dots
writeEPS('discrete_timesignal','font12Only');

%show an undersampled signal
clf
newt=t(1:4:end);
newy=y(1:4:end);
ak_impulseplot(newy,newt,[]);
hold on
ak_timeplot(t,y,'Color','k','LineStyle',':');
xx = 0.004875 + 0.4e-3;
yy = 3.841;
text(xx,yy,'\leftarrow notice','fontsize',18);
ak_add3dots
writeEPS('undersampled');
