% Create figure using manual input of annotations (later I learned how to
% do it "programmatically"

%Define vectors
x=[2,2]; %define a vector x
y=[5,1]; %define a vector y
magx=sqrt(sum(x.*x)) %magnitude of x
magy=sqrt(sum(y.*y)) %magnitude of y
innerprod=sum(x.*y)  %inner product <x,y>=|x| |y| cos(theta)
theta = acos(innerprod / (magx*magy)) %find the angle theta between x and y
%obs: could use acosd to have angle in degrees
disp(['Angle is ' num2str(180*theta/pi) ' degrees']);
%find the projection of x over y (called p_xy) and p_yx
mag_p_xy = magx*cos(theta); %magnitude of p_xy
y_unitary=y/magy; %normalize y by magy to get unitary vector
p_xy = mag_p_xy * y_unitary; %p_xy is in the direction of y. 
mag_p_yx = magy*cos(theta); %magnitude of p_yx
x_unitary=x/magx; %normalize x by magx to get unitary vector
p_yx = mag_p_yx * x_unitary; %p_yx is in the direction of x.
%test orthogonality of error vectors
error_xy = x - p_xy; %we know: p_xy + error_xy = x
sum(error_xy.*y) %this inner product should be zero
error_yx = y - p_yx; %we know: p_yx + error_yx = y
sum(error_yx.*x) %this inner product should be zero

%first figure
%create figure using the ak_drawvector function
close all
axis([0 5 0 3.5])
%set(gca,'DataAspectRatio',[1 1 1]) %relative magnitudes along each axis
%are equal with respect to each other
grid

ak_drawvector(x(1),x(2));
text(x(1)-0.2,x(2),'x','FontSize',12,'FontWeight','bold')

ak_drawvector(y(1),y(2));
text(y(1)-0.1,y(2)-0.2,'y','FontSize',12,'FontWeight','bold')

[h,cx,cy]=ak_drawvector(p_xy(1),p_xy(2));
set(h,'color','blue','linewidth',2);
text(p_xy(1)-0.1,p_xy(2)-0.2,'p_{xy}','FontSize',12,'FontWeight','bold',...
    'color','blue')

line([x(1),p_xy(1)],[x(2),p_xy(2)],'LineStyle','-.','color','red',...
    'linewidth',2);

text(0.6,0.3,{'\theta'},'FontWeight','bold','FontSize',14);
set(gcf,'Position',[360 272 652 426]);
writeEPS('projection_using_innerprod');

%second figure, plot vectors
%create figure using the ak_drawvector function
clf
close all
axis([0 5 0 3.5])
%set(gca,'DataAspectRatio',[1 1 1]) %relative magnitudes along each axis
%are equal with respect to each other
grid
[h,cx,cy]=ak_drawvector(p_xy(1),p_xy(2));
set(h,'color','blue');
text(p_xy(1)-0.1,p_xy(2)-0.2,'p_{xy}','FontSize',12,'FontWeight','bold',...
    'color','blue')

ak_drawvector(x(1),x(2));
text(x(1)-0.2,x(2),'x','FontSize',12,'FontWeight','bold')

ak_drawvector(y(1),y(2));
text(y(1)-0.1,y(2)-0.2,'y','FontSize',12,'FontWeight','bold')

h2=ak_drawvector(p_yx(1),p_yx(2));
set(h2,'color','blue');
text(p_yx(1)+0.1,p_yx(2),'p_{yx}','FontSize',12,'FontWeight','bold',...
    'color','blue')

%error_xy = x - p_xy; %we know: p_xy + error_xy = x
%if wanted to change the origin:
h3=ak_drawvector(x(1),x(2),p_xy(1),p_xy(2));
%h3=ak_drawvector(error_xy(1),error_xy(2));
text(2-0.1,1,'e_{xy}','FontSize',12,'FontWeight',...
    'bold','color','red')
set(h3,'color','red');

h4=ak_drawvector(y(1),y(2),p_yx(1),p_yx(2));
%h4=ak_drawvector(error_yx(1),error_yx(2));
set(h4,'color','red');
text(4,2,'e_{yx}','FontSize',12,'FontWeight',...
    'bold','color','red')

set(gcf,'Position',[360 272 652 426]);

writeEPS('projection_vectors');
hold off
close all