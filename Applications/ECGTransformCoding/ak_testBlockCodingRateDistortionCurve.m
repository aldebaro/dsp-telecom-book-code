%simple function to provide example of building a rate distortion curve
function [h,signalPower]=ak_testBlockCodingRateDistortionCurve(M)
%M= is the transform dimension
%build a linear transform. Note: the columns of A are the basis
%functions. I will choose functions that are smooth and others "nervous"
if 1 %choose between two interesting options
    Ainverse=octave_dctmtx(M); %dctmtx outputs matrices for the direct transform
    A=inv(Ainverse); %DCT matrix
else %use an arbitrary non-singular matrix
    M=4;
    A =[1 0  1  0;  %note that because A is not unitary in this example
        1 1  0  1;  %the first basis [1 1 1 1] does not represent the
        1 2 -1  0   %DC (mean) level of the signal.
        1 3  0  1];
    Ainverse = inv(A);
end

myPath='./ecg_data'; %directory of interest (where the files are)
samplesToRead = inf; %number of samples to read. Use inf for all
shouldPlot = 0; %if 0 does not show plot, but if 1 it does show
%Test set (used for evaluation purposes):
fileNames=['11950_03'; '12713_01'; '11442_01'; '12247_03'];
x=[]; %initialize input signal
for i=1:4
    fileName = fileNames(i,:);
    [twoChannelSignals, time] = ak_rddata(myPath, fileName, ...
        samplesToRead, shouldPlot);
    %concatenate two channels to previous x:
    x=[x;twoChannelSignals(:,1);twoChannelSignals(:,2)]; 
end

%calculate the signal power in Watts assuming the signal is in mV
signalPower = sum(x.^2) * (10^-6);

%allocate space and initialize with zeros
rts = zeros(1,M);
mses = zeros(1,M);
for K=1:M-1   %K is the number of coefficient that should be kept (the
    %others are discarded). Do not calculate K=M because it leads to zero
    %error
    X=ak_1dBlockCoding(x,A,K); %encoding
    x2=ak_1dBlockDecoding(X,Ainverse,K); %decoding
    error = x-x2; %calculate the error
    mse = mean(error.^2)*1e-6; %calculate the mean square error (MSE) in W
    mses(K) = mse; %store new MSE value
    rt = 100*K/M; %calculate the ratio between the input and output vectors
    rts(K) = rt; %store new RT value
    disp(['MSE = ' num2str(mse) ' (Watts) and percentage ' ...
        'of kept coefficients = ' num2str(rt)]);
end

h=plot(rts,10*log10(mses));
xlabel('percentage of kept coefficients (%)');
ylabel('10 log_{10}(MSE)  (in dBW)'); grid
end