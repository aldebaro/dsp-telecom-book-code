W0 = 1; % signal angular frequency in rad
A = 3; % signal amplitude in V
N = 1000; % window duration in samples
rect_window = ones(1, N); % rectangular window
M = 10000; % samples to represent infinite duration signal
n = 0:M-1; % long duration discrete-time axis
x = A*cos(2*pi*W0*n); % signal of long duration
xw = x(1:N) .* rect_window; % windowing
subplot(311)
w=[-W0 W0]; Xw=0.5*pi*[A A]; 
h=ak_impulseplot(Xw,w,[]);
xlabel(''), ylabel('X(e^{j\Omega})')
axis([-pi pi 0 A*N/2+2])
%ak_makedatatip(h,[-W0, Xw(1)])
whereToPlace='auto'; ak_makedatatip(h,[W0, Xw(2)], whereToPlace)
subplot(312)
% discretize the frequency axis in large number M of points
Omega = linspace(-pi, pi, M); 
%add frequency values of interest to facilitate plots
Omega = sort([Omega -W0 W0 0]);
W_div_2 = Omega/2; %speed up things computing only once
rect_window_dtft=(sin(N*W_div_2)./sin(W_div_2)).*exp(-1j*W_div_2*(N-1));
rect_window_dtft(isnan(rect_window_dtft))=N; %L'Hospital rule to correct NaN if 0/0
h=plot(Omega, abs(rect_window_dtft));
xlabel(''), ylabel('W(e^{j\Omega})')
axis([-pi pi 0 A*N/2+2])
whereToPlace='auto'; ak_makedatatip(h,[0, N], whereToPlace)
subplot(313)
W_div_2 = (Omega+W0)/2; %speed up things computing only once
dtft_parcel1=(sin(N*W_div_2)./sin(W_div_2)).*exp(-1j*W_div_2*(N-1));
dtft_parcel1(isnan(dtft_parcel1))=N; %L'Hospital rule to correct NaN if 0/0
W_div_2 = (Omega-W0)/2; %speed up things computing only once
dtft_parcel2=(sin(N*W_div_2)./sin(W_div_2)).*exp(-1j*W_div_2*(N-1));
dtft_parcel2(isnan(dtft_parcel2))=N; %L'Hospital rule to correct NaN if 0/0
Xw = (A/2)*(dtft_parcel1 + dtft_parcel2);
h=plot(Omega, abs(Xw));
axis([-pi pi 0 A*N/2+2])
W0_index = find(Omega==-W0);
whereToPlace='southeast'; ak_makedatatip(h,[-W0, Xw(W0_index)], whereToPlace)
xlabel('\Omega (rad)'), ylabel('X_w(e^{j\Omega})')