myfigure=clf; %get a handler to manipulate the figure
%load black & white 256 x 256 pixels of Lenna:
fullPath='lenna_bw.gif' %file location
  [lenaImage,map]=imread(fullPath); %read file
colormap(map); %use the proper color map
x1=128; x2=135; y1=160; y2=167; %to take a 8x8 block close to her eye
x=lenaImage(x1:x2,y1:y2); %get the region
x=double(x); %cast x to be double instead of integer
%draw a rectangle to indicate the block:
lenaImage(x1,y1:y2)=1; lenaImage(x2,y1:y2)=1;
lenaImage(x1:x2,y1)=1; lenaImage(x1:x2,y2)=1;
imagesc(lenaImage) %show the image
annotation(myfigure,'arrow',[0.5393 0.5908],... % Create arrow
    [0.7371 0.5407],'LineWidth',1,'Color',[1 0 0]);
axis equal %correct the aspect ratio
%Some calculations to practice:
X=octave_dct2(x); %calculate forward DCT
x2=octave_idct2(X); %calculate inverse DCT to check
numericError = max(x(:)-x2(:)) %any numeric error?
Ah=octave_dctmtx(8); %now calculate in an alternative way
X2 = Ah*x*transpose(Ah);
%X2 = transpose(Ah)*x*Ah; %Note: this would be wrong!
numericError2 = max(X(:)-X2(:)) %any numeric error?
writeEPS('lenna_eye'); %write figure to EPS file
