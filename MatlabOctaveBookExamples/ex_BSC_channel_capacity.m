%capacity of a BSC channel
M=10000000; %number of bits per I(X,Y) estimation
p=0.45; %probability of flipping the bit
N=10; %grid for p1
num_binx=2; %number of bins for histograms, 2 because binary values
num_biny=2;

%theoretical result
%The capacity of the BSC is 1 - h(p)
hp = -p*log2(p) - (1-p)*log2(1-p)
if isnan(hp)
    hp=0; %impose 0log0 = 0
end

%input distribution
p1range = linspace(0,0.5,N); %range of possible values of
x=zeros(1,M); %pre-allocate space
y=zeros(1,M);
maximumMutualInfo = -Inf; %initialize
bestp1 = NaN;
for n=1:N
    %generate the source
    p1=p1range(n);
    x=rand(1,M);
    indices1 = x<p1;
    x(indices1)=1;
    x(~indices1)=0;
    %transmit through channel (vectorize to avoid loop)
    y=x;
    %choose which bits to flip, with probability p
    temporary = rand(1,M);
    indicesFlip = temporary < p;
    y(indicesFlip) = ~y(indicesFlip); %generate bit errors
    [histogram2d,xaxis,yaxis]=ak_hist2d(x,y,num_binx,num_biny);
    meshc(xaxis,yaxis,histogram2d); xlabel('x'); ylabel('y'); %to plot
    %histogram2d = (column is x and row is y
    %   0/0           1/0
    %   0/1           1/1  
    pXY = histogram2d / sum(histogram2d(:));
    pX = sum(pXY,1); %marginalize to get distributions for X and Y
    pY = sum(pXY,2);
    temporary = pXY.*log2(pXY./(pY*pX)); %tricky, it is not pX*pY: note we want the outer product of pY and pX
    temporary(isnan(temporary))=0;
    mutualInfo = sum(temporary(:));
    disp(['p1=' num2str(p1) ', p1_generated=' num2str(pX(2)) ', I(X;Y)=' num2str(mutualInfo) ' bits'])
    if mutualInfo > maximumMutualInfo 
        maximumMutualInfo = mutualInfo;
        bestp1 = pX(2); %note the actual, not desired value p1 is used
        bestpXY = pXY;
    end
end

disp(['Final result for p=' num2str(p) ': best p1_generated=' num2str(bestp1) ', C=max_x I(X;Y)=' num2str(maximumMutualInfo) ' bits'])
disp(['Theoretical C = ' num2str(1-hp) ' bits (per channel use)'])