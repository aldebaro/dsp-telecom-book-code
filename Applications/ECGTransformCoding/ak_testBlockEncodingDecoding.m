%simple script to test both encoding and decoding stages
%do not use ECG, only a short signal
M=4; %transform dimension
if 0 %choose between two interesting options
    x=randn(2*M,1); %create a random signal with two blocks of M samples each
else
    x=transpose(1:2*M);
end

%build a linear transform. Note: the columns of A are the basis
%functions. I will choose functions that are smooth and others "nervous"
if 1 %choose between two interesting options
    Ainverse=dctmtx(M); %dctmtx outputs matrices for the direct transform
    A=inv(Ainverse); %DCT matrix
else %use an arbitrary non-singular matrix
    A =[1 0  1  0;  %note that because A is not unitary in this example
        1 1  0  1;  %the first basis [1 1 1 1] does not represent the
        1 2 -1  0   %DC (mean) level of the signal.
        1 3  0  1];
    Ainverse = inv(A);
    M=4;
end
%plot(A) %plot basis functions

%simple example of encoding/decoding
K=1; %K is the number of coefficient that should be kept (the
%others are discarded)
X=ak_1dBlockCoding(x,Ainverse,K); %encoding
x2=ak_1dBlockDecoding(X,A,K); %decoding

%analysis
error = x-x2; %calculate the error
abscissa=1:length(x);
clf; %clear previous figure, if exists
plot(abscissa,x,abscissa,x2,abscissa,error) %show plots
legend('original','reconstructed','error');
mse = mean(error.^2); %calculate the mean square error (MSE)
rt = 100*K/M; %calculate the ratio between the output and input lengths
disp(['MSE = ' num2str(mse)]);
disp(['RT = ' num2str(rt)]);
