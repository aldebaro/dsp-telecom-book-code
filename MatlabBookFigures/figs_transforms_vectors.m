%draw figure 2d

x=-10:10;
z=zeros(size(x));
figure1 = clf;
plot(x,z)
hold on
plot(z,x)
%axis equal
axis([-10 10 -10 10])
% Create arrow
annotation(figure1,'arrow',[0.5179 0.6714],[0.5133 0.8429],'LineWidth',3);

% Create arrow
annotation(figure1,'arrow',[0.5179 0.8268],[0.5133 0.3548],'LineWidth',3);
%annotation(figure1,'arrow',[0.517 0.6747],[0.5185 0.1931],'LineWidth',3);

% Create arrow
annotation(figure1,'arrow',[0.5179 0.5597],[0.5133 0.5185],'LineWidth',2,...
    'Color',[1 0 0]);

% Create arrow
annotation(figure1,'arrow',[0.5161 0.5142],[0.5133 0.5794],'LineWidth',2,...
    'Color',[1 0 0]);

% Create textbox
annotation(figure1,'textbox','Interpreter','latex',...
    'String',{'$\mathbf{x}$'},...
    'FontSize',20,...
    'FitHeightToText','off',...
    'LineStyle','none',...
    'Position',[0.6349 0.6277 0.1278 0.1199]);

% Create textbox
annotation(figure1,'textbox','Interpreter','latex',...
    'String',{'$\mathbf{y}$'},...
    'FontSize',20,...
    'FitHeightToText','off',...
    'LineStyle','none',...
    'Position',[0.6887 0.3656 0.215 0.1305]);

% Create textbox
annotation(figure1,'textbox','Interpreter','latex',...
    'String',{'$\overline{i}$'},...
    'FontSize',20,...
    'FitHeightToText','off',...
    'LineStyle','none',...
    'Position',[0.5214 0.3715 0.215 0.1305]);

% Create textbox
annotation(figure1,'textbox','Interpreter','latex',...
    'String',{'$\overline{j}$'},...
    'FontSize',20,...
    'FitHeightToText','off',...
    'LineStyle','none',...
    'Position',[0.4745 0.4622 0.215 0.1464]);

grid

if 0
    theta = pi/2;
    A=[cos(theta) sin(theta)
        -sin(theta) cos(theta)];
    x=[4; 8];
    y=A*x
    y2=x'*A
end

%annotation(myfigure,'arrow',[0.5179 y(1)],[0.5133 y(2)],'LineWidth',3);
writeEPS('orthogonal_2d_vectors');

%draw figure 3d with 3-d vectors
clf
%line or cylinder:
%Error: origin is not in (0,0,0)!!!
arrow3d([0 0 0], [4 3 2],30,'cylinder',[.1,0.1],[20,10])
grid
arrow3d([0 0 0], [0 0 2],30,'cylinder',[.1,0.1],[20,10])
arrow3d([0 0 0], [0 3 0],30,'cylinder',[.1,0.1],[20,10])
arrow3d([0 0 0], [4 0 0],30,'cylinder',[.1,0.1],[20,10])
xlabel('x')
ylabel('y')
zlabel('z')
writeEPS('orthogonal_3d_vectors')
clf