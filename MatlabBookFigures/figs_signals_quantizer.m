%% Non-uniform quantization of a mixture of Gaussians with Lloyd's algorithm
clear all, clf
N=100000; %number of random samples
weight1=0.8; %weight from 0 to 1
weight2=1-weight1; %weight from 0 to 1
mean1 = -4;
var1 = 0.5;
mean2 = 3;
var2 = 4;
b=3; %number of bits
N1=round(weight1*N);
N2=N-N1;
x1=mean1+sqrt(var1)*randn(1,N1); %Gaussian samples
x2=mean2+sqrt(var2)*randn(1,N2); %Gaussian samples
x=[x1, x2]; %concatenate, mix the 2 Gaussians
M=2^b;
numBins=100; %number of bins
[partition,codebook] = lloyds(x,M); %design the quantizer
[pdf_approximation,abcissa] = ak_normalize_histogram(x,numBins);
plot(abcissa, pdf_approximation);
hold on
fxx = weight1*normpdf(linspace(abcissa(1),abcissa(end),numBins),mean1,sqrt(var1)) + ...
    (1-weight1)*normpdf(linspace(abcissa(1),abcissa(end),numBins),mean2,sqrt(var2));
plot(abcissa, fxx);
for i=1:length(partition) %plot each partition boundary
    plot([partition(i), partition(i)],[0, 1],'--','Color','b');
end
plot(codebook,zeros(size(codebook)),'o','Color','k'); %quantization levels
myaxis=axis;
myaxis(4)=max(pdf_approximation); %limit max value
axis(myaxis) %set new axis
legend('Estimated PDF','Theoretical PDF');
xlabel('Input')
ylabel('PDF likelihood')
writeEPS('gaussian_mixture_quantization','font12Only');

clf
x=linspace(abcissa(1),abcissa(end),50000); 
x_hat=ak_nonuniform_quantizer(x,codebook);
plot(x,x_hat)
grid
xlabel('Input')
ylabel('Output')
axis tight
writeEPS('gaussian_mixture_stairs');

%% Non-uniform quantization input-output for Gaussian
codebook=[-6.8, -4.2, -2.4, -0.8, 0.8, 2.4, 4.2, 6.8];
x=linspace(-8,8,50000); 
x_hat=ak_nonuniform_quantizer(x,codebook);
plot(x,x_hat)
grid
xlabel('Input')
ylabel('Output')
writeEPS('gauss_quantization');

%% Non-uniform quantization input-output
codebook=[-4,-1,0,3];
x=linspace(-6,6,50000); 
x_hat=ak_nonuniform_quantizer(x,codebook);
plot(x,x_hat)
grid
xlabel('Input')
ylabel('Output')
writeEPS('nonuniform_quantization');

%% Non-uniform quantization with Lloyd's algorithm
clf
N=1000000; %number of random samples
b=3; %number of bits
variance = 10;
x=sqrt(variance)*randn(1,N); %Gaussian samples
M=2^b;
numBins=100; %number of bins
[partition,codebook] = lloyds(x,M); %design the quantizer
[pdf_approximation,abcissa] = ak_normalize_histogram(x,numBins);
plot(abcissa, pdf_approximation);
hold on
fxx = normpdf(linspace(abcissa(1),abcissa(end),numBins),0,sqrt(variance));
plot(abcissa, fxx);
for i=1:length(partition) %plot each partition boundary
    plot([partition(i), partition(i)],[0, 1],'--','Color','b');
end
plot(codebook,zeros(size(codebook)),'o','Color','k'); %quantization levels
myaxis=axis;
myaxis(4)=max(pdf_approximation); %limit max value
axis(myaxis) %set new axis
legend('Estimated PDF','Theoretical PDF');
xlabel('Input')
ylabel('PDF likelihood')
writeEPS('gaussian_quantization','font12Only');

%% Float vs double precision
clf
N=300; delta_x=zeros(1,N); x=linspace(-8,8,N); %define range
for i=1:N, delta_x(i) = eps(single(x(i))); end %use loop to be compatible with Octave
semilogy(x,delta_x); hold on
for i=1:N, delta_x(i) = eps(x(i)); end %use loop to be compatible with Octave
semilogy(x,delta_x,'r:'); legend1 = legend('float','double');
xlabel('x'), ylabel('\Delta(x)')
set(legend1,'Position',[0.7158 0.7067 0.1714 0.1]);
grid
writeEPS('singleVsDoublePrecision')

%a 3-bits mid-tread quantizer
close all
figure1 = figure;
maxX=5;
hold on, plot([-maxX,maxX],[0,0],'k') %x and y axes
plot([0,0],[-maxX,maxX],'k')
delta = 1;
x=delta*[-maxX -5 -4 -3  -2  -1 0 1 2 3 4 5 maxX]-delta/2;
y=delta*[-4 -4 -4  -3 -2 -1 0  1  2  3  3 3 3];
stairs(x,y,'linewidth',3)
plot(-4.5*[1,1],[-maxX,maxX],'r--','linewidth',2) %overload regions
plot(3.5*[1,1],[-maxX,maxX],'r--','linewidth',2) %overload regions
z = abs(max(x));
xlabel('input x')
ylabel('output x_q')
set(gca,'XTick',[-7.5 -6.5 -5.5 -4.5 -3.5 -2.5 -1.5 -0.5 0.5 1.5 2.5 3.5 4.5 5.5 6.5 7.5]);
set(gca,'YTick',-maxX:maxX)
axis([-z z -z z])
grid
% Create textarrow
annotation(figure1,'textarrow',[0.3036 0.1732],...
    [0.8038 0.6429],'TextEdgeColor','none',...
    'String',{'Negative','overload','region'});

% Create textarrow
annotation(figure1,'textarrow',[0.6589 0.8714],...
    [0.799 0.7333],'TextEdgeColor','none',...
    'String',{'Positive','overload','region'});

axis equal
% Create textbox
annotation(figure1,'textbox','String',{'...'},...
    'FontSize',18,...
    'FontName','Arial Narrow',...
    'FitHeightToText','off',...
    'EdgeColor',[1 1 1],...
        'LineStyle','none',...
    'Position',[0.1289 0.2181 0.06607 0.05138]);

% Create textbox
annotation(figure1,'textbox','String',{'...'},...
    'FontSize',18,...
    'FontName','Arial Narrow',...
    'FitHeightToText','off',...
    'EdgeColor',[1 1 1],...
        'LineStyle','none',...
    'Position',[0.8339 0.8071 0.06607 0.05138]);

writeEPS('quantizerdelta1','font12Only');


%another 3-bits mid-tread quantizer
close all
figure1 = figure;
maxX=5;
hold on, plot([-maxX,maxX],[0,0],'k') %x and y axes
plot([0,0],[-maxX,maxX],'k')
delta = 0.5;
x=delta*[-maxX -5 -4 -3  -2  -1 0 1 2 3 4 5 maxX]-delta/2;
y=delta*[-4 -4 -4  -3 -2 -1 0  1  2  3  3 3 3];
stairs(x,y,'linewidth',3)
plot(-2.25*[1,1],[-maxX,maxX],'r--','linewidth',2) %overload regions
plot(1.75*[1,1],[-maxX,maxX],'r--','linewidth',2) %overload regions
z = abs(max(x));
xlabel('input x')
ylabel('output x_q')
set(gca,'XTick',[-2.25:delta:1.75]);
set(gca,'XTickLabel',{'-2.25',' ','-1.25',' ','-0.25','0.25',' ','1.25','1.75'});
set(gca,'YTick',-4:delta:3)
grid
% Create textarrow
annotation(figure1,'textarrow',[0.247 0.1996],...
    [0.4252 0.2333],'TextEdgeColor','none',...
    'TextBackgroundColor',[1 1 1],...
    'String',{'Negative','overload','region'});

% Create textarrow
annotation(figure1,'textarrow',[0.6946 0.8161],...
    [0.8323 0.8071],'TextEdgeColor','none',...
    'TextBackgroundColor',[1 1 1],...
    'String',{'Positive','overload','region'});

axis([-3.25 2.75 -z z])
axis equal

% Create textbox
annotation(figure1,'textbox','String',{'...'},...
    'FontSize',18,...
    'FontName','Arial Narrow',...
    'FitHeightToText','off',...
    'EdgeColor',[1 1 1],...
    'LineStyle','none',...
    'Position',[0.8286 0.7381 0.05536 0.08471]);

% Create textbox
annotation(figure1,'textbox','String',{'...'},...
    'FontSize',18,...
    'FontName','Arial Narrow',...
    'FitHeightToText','off',...
    'EdgeColor',[1 1 1],...
    'LineStyle','none',...
    'Position',[0.1396 0.2038 0.05536 0.08471]);

writeEPS('quantizerdelta05','font12Only');
