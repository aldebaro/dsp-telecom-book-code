N=10000;
w=linspace(-pi,pi,N);
Xejw = 1./(1-0.9*exp(-j*w));
plot(w,abs(Xejw))
Fs=5000; Ts=1/Fs;
W=linspace(-4*2*pi*Fs,4*2*pi*Fs,N);
XejW = 1./(1-0.9*exp(-j*W*Ts));
plot(W,abs(XejW))

