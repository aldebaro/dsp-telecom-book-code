N=2 %the FIR order is M=2N in this case
n=-N:N %time indices
wc = pi/3 %specified cutoff frequency
hn = sin(wc * n) ./ (pi * n) %ideal filter response
hn(N+1)=wc/pi %correct undetermined value hn=0/0 at n=0
hn = hn/sum(hn) %normalize filter to have gain 1 at DC
B=fir1(2*N,wc/pi,rectwin(2*N+1)) %alternatively, use fir1
max(abs(hn-B)) %compare hn with B obtained with fir1
