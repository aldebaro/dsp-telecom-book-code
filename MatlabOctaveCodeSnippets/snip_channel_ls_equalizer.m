Nw=10; %number of equalizer coefficients
h=[0.1; 0; 0; 0.5; 3; 0.2; -0.1]; %channel impulse response
Nh=length(h); %number of impulse response coefficients
Hhat=convmtx(h,Nw); %convolution matrix. Note that Hhat*w = conv(w,h)
Nc=Nw+Nh-1; %number of elements in convolution output
MSEvalues=zeros(Nc,1); %pre-allocate space
for Delta=1:Nc %search for best delay Delta
    e=zeros(Nc,1); e(Delta)=1; %create vector to mimic impulse
    w=inv(Hhat'*Hhat)*Hhat'*e; %design equalizer via least squares
    %w2=pinv(Hhat)*e; max(abs(w-w2)) %compare with pinv
    MSEvalues(Delta)=mean(abs(Hhat*w - e).^2); %calculate MSE
end
stem(1:Nc,MSEvalues), xlabel('delay \Delta'), ylabel('MSE') %plot
[minMSE,bestDelta]=min(MSEvalues) %find best delay and its MSE
guessBestDelta=round((Nc-1)/2) %guess best delay value
e=zeros(Nc,1); e(bestDelta)=1; %create vector with best delay
wbest=inv(Hhat'*Hhat)*Hhat'*e; %best equalizer