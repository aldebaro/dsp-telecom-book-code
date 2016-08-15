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
