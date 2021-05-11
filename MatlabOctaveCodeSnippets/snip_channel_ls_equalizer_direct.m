rng('default'), rng(10); %set a seed
Nw=5; %number of equalizer coefficients
h=[0.1; 0; 0; 0.5; 3; 0.2; -0.1]; %channel impulse response
x=transpose(1:11); %arbitrary training sequence as column vector
Nx=length(x);
if Nw >= Nx
    error('System should be overdetermined. Use Nw < Nx')
end
y=conv(x,h); %convolve input with channel impulse response
Ycomplete=convmtx(y,Nw); %complete convolution matrix
%Ycomplete=convmtx(transpose(1:Ny),Nw) %complete convolution matrix
[Ny temp]=size(Ycomplete); %Ny=Nx+length(h)+Nw-2, result of 2 conv's
MSEvalues=zeros(Ny-Nx+1,1); %pre-allocate space
for Delta=1:Ny-Nx+1 %Ny-Nx+1 %search for best delay Delta
    Yhat=Ycomplete(Delta:Delta+Nx-1,:); %delayed convolution matrix
    w=pinv(Yhat)*x; %find the equalizer    
    %w2=inv(Yhat'*Yhat)*Yhat'*x; %design using the property
    %max(abs(w-w2)) %compare with pinv
    MSEvalues(Delta)=mean(abs(Yhat*w - x).^2); %calculate MSE
end
stem(1:Ny-Nx+1,MSEvalues), xlabel('delay \Delta'), ylabel('MSE')%plot
[minMSE,bestDelta]=min(MSEvalues) %find best delay and its MSE
Yhat=Ycomplete(bestDelta:bestDelta+Nx-1,:); %convolution matrix
wbest=pinv(Yhat)*x; %find the equalizer    
%wbest2=inv(Yhat'*Yhat)*Yhat'*x; %find the equalizer
%% Check equalization performance
stem(conv(h,wbest))