%% Low pass FIR design via windowing
N=2; %the FIR order is M=2N in this case
n=-N:N; %time indices
wc = pi/3 %specified cutoff frequency
h_ideal = sin(wc * n) ./ (pi * n) %ideal filter response
h_ideal(N+1)=wc/pi %correct undetermined value 0/0 at n=0
%% "Manually" design FIR with rectangular window
% a rectangular window has values 1, no need to multiply
hn = h_ideal/sum(h_ideal) %normalize to have gain 1 at DC
%% "Automatically" design FIR using windowing via fir1
B=fir1(2*N,wc/pi,rectwin(2*N+1)) %alternatively, use fir1
max(abs(hn-B)) %compare hn with B obtained with fir1
%% "Manually" design (another) FIR with Hamming window
window_hamming = transpose(hamming(2*N+1)); %window
hn = h_ideal .* window_hamming; %multiply in time-domain
hn = hn/sum(hn) %normalize filter to have gain 1 at DC
%% "Automatically" design FIR using windowing via fir1
B=fir1(2*N,wc/pi,hamming(2*N+1)) %alternatively, use fir1
max(abs(hn-B)) %compare hn with B obtained with fir1