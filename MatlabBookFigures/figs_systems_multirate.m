close all
%figure(1);

%% plot one filter only
% Wc=1/4;
% Wmax=10
% W=[-Wmax -Wc -Wc Wc Wc Wmax];
% H=[0      0    1  1  0  0];
% plot(W,H)

%% Downsampler    
topPlot=subplot(211);
hold on
myticks=[];
for i=-4:4
    Wc=1/4;
    %myticks=[myticks 2*i-Wc 2*i+Wc];
    myticks=[myticks 2*i];
    W=[ 2*i-Wc 2*i 2*i+Wc ];
    H=[          0  1 0    ];
    plot(W,H)
    %pause
end
ylabel('Z(e^{j \Omega})')
set(gca,'Xtick',myticks);
%axis([-12 12 0 1.05])
%ak_add3dots

%ak_add3dots messes up with the alignment and tried:
% from https://www.mathworks.com/matlabcentral/answers/108737-aligning-subplots-width-in-a-figure

botPlot=subplot(212);
hold on
%myticks=[];
M=3;
mycolors=['b','r','k'];
for m=0:M-1;
for i=-4:4
    Wc=M*1/4;
    %myticks=[myticks 2*i-Wc 2*i+Wc];
    %myticks=[myticks M*2*i];

    W=2*m+[M*2*i-Wc M*2*i M*2*i+Wc ];
    H=[          0  1 0    ];    
    eval(['plot(W,(1/M)*H,''' mycolors(m+1) ''')'])
    %pause
end
end
set(gca,'Xtick',myticks);
ylabel('Y(e^{j \Omega})')
%axis([-12 12 0 1.05])
%ak_add3dots

xlabel('f (normalized) = \Omega  / \pi')
subplot(211)
axis([-8.5 8.5 0 1.05])
subplot(212)
axis([-8.5 8.5 0 1.05])

writeEPS('downsampling_example','font12Only')

return
%Obs: I ended up coloring this figure by hand and adding it
%at the FiguresNonScript folder.
%% Upsampler
clf
%figure(1);
topPlot=subplot(211);
hold on
myticks=[];
for i=-3:3
    Wc=1/4;
    %myticks=[myticks 2*i-Wc 2*i+Wc];
    myticks=[myticks 2*i];
    W=[2*i-Wc 2*i-Wc 2*i+Wc 2*i+Wc ];
    H=[      0    1  1  0  ];
    plot(W,H)
    %pause
end
ylabel('X(e^{j \Omega})')
set(gca,'Xtick',myticks);
%axis([-12 12 0 1.05])
%ak_add3dots

%ak_add3dots messes up with the alignment and tried:
% from https://www.mathworks.com/matlabcentral/answers/108737-aligning-subplots-width-in-a-figure

%figure(2);
botPlot=subplot(212);
hold on
myticks=[];
L=4;
for i=-L*3:L*3
    Wc=1/4/L;
    %myticks=[myticks 2*i-Wc 2*i+Wc];
    myticks=[myticks 2*i/L];
    W=(1/L)*[2*i-Wc 2*i-Wc 2*i+Wc 2*i+Wc];
    H=[      0    1  1  0  ];
    plot(W,H)
    %pause
end
set(gca,'Xtick',myticks);
ylabel('Q(e^{j \Omega})')
%axis([-12 12 0 1.05])
%ak_add3dots

xlabel('f (normalized) = \Omega  / \pi')
subplot(211)
axis([-6.5 6.5 0 1.05])
subplot(212)
axis([-6.5 6.5 0 1.05])

%writeEPS('upsampling','font12Only')
