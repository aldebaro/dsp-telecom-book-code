close all

%generate example of signal
snip_discrete_signal_generation
xlabel('n');
ylabel('x[n]');
grid
writeEPS('discrete_cosine');

%generate example of oversampled signal
snip_oversampled_signal
subplot(211)
ylabel('x_1(t)'), axis tight
subplot(212)
xlabel('t (s)')
ylabel('x_2(t)'), axis tight
writeEPS('oversampled_cosine');

%generate example of y[n]=x[-n]
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
%

%% Illustrate ZOH
close all
clf
subplot(131)
xn=[0.5 -2.8   1.3  3.5 -1.7  1.1  4];
N=length(xn);
stem(0:N-1,xn)
xlabel('Discrete-time n')
ylabel('x[n]')
grid
subplot(132)
%xs
%T=0.2; ak_sampledsignalsplot(x,[],T,'color','r')
Ts=0.2; ak_sampledsignalsplot(xn,[],Ts)
ylabel('x_s(t)')
grid
subplot(133)
L=200; xt=ak_zeroOrderHolder(xn, L);
t=linspace(0,N*Ts,length(xt));
plot(t,xt)
xlabel('Time (s)')
ylabel('x(t)')
%myaxis=axis
%subplot(132)
%axis(myaxis)
grid
%To resize and make a figura shorter:
x=get(gcf, 'Position'); %get figure's position on screen
x(4)=floor(x(4)*0.5); %adjust the size making it "taller"
set(gcf, 'Position',x);
writeEPS('zoh_reconstruction');


%% Illustrate perfect sinc reconstruction
close all
clf
max_n = 4; %n varies from -max_n to max_n
subplot(311)
xn=[1 -3   3];
N=length(xn);
xn_extended=zeros(1,2*max_n+1);
xn_extended(max_n+1:max_n+N)=xn;
stem(-max_n:max_n, xn_extended)
%hold on
%stem(0:N-1,xn)
xlabel('Discrete-time n')
ylabel('x[n]')
grid
subplot(312)
%xs
%T=0.2; ak_sampledsignalsplot(x,[],T,'color','r')
Ts=0.2; ak_sampledsignalsplot(xn,[],Ts,'color','b')
hold on
t=(-max_n:max_n)*Ts;
plot(t,zeros(1,length(t)),'color','b');
ylabel('x_s(t)')
axis tight
grid
subplot(313)
[xt, t, x_parcels] = ak_sinc_interpolation(xn,Ts,0,max_n*Ts);
plot(t,xt); %,'--','LineWidth',1.5);
ylabel('x(t)')
xlabel('Time (s)')
writeEPS('sinc_reconstruction','font12Only');

%% Show the parcels (each sinc) in sinc reconstruction
clf
ak_sinc_interpolation(xn,Ts,0,max_n*Ts);
writeEPS('sum_sinc_reconstruction','font12Only');