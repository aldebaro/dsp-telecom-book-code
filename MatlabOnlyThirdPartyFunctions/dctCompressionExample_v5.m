% Example app for http://blogs.mathworks.com/steve
%
% Steve Eddins
% Copyright 2013 The MathWorks, Inc.

classdef dctCompressionExample_v5 < handle
    
    properties (SetAccess = private)
        OriginalImage
        ReconstructedImage
        ErrorImage
        DCTCoefficientMask
    end
    
    properties (Dependent)
        NumDCTCoefficients
    end
    
    properties (Access = private)
        Slider
        OriginalImageAxes
        ReconstructedImageAxes
        ErrorImageAxes
        MaskAxes
    end
    
    methods
        function this_app = dctCompressionExample_v5
            this_app.OriginalImage = initialImage;
            layoutApp(this_app);
            this_app.NumDCTCoefficients = 3;
            update(this_app);
        end
        
        function layoutApp(app)
            f = figure;
            app.OriginalImageAxes = axes('Parent',f, ...
                'Position',[0.05 0.56 0.35 0.35]);
            app.ReconstructedImageAxes = axes('Parent',f, ...
                'Position',[0.60 0.56 0.35 0.35]);
            app.MaskAxes = axes('Parent',f, ...
                'Position',[0.05 0.12 0.35 0.35]);
            app.ErrorImageAxes = axes('Parent',f, ...
                'Position',[0.60 0.12 0.35 0.35]);
            app.Slider = uicontrol('Style','slider', ...
                'Units','normalized', ...
                'Position',[0.05 0.04 0.33 0.04], ...
                'Callback',@(~,~,~) app.reactToSliderChange);
        end
        
        function reactToSliderChange(app)
            v = get(app.Slider,'Value');
            app.NumDCTCoefficients = round(64*v);
            update(app);
        end
        
        function value = get.NumDCTCoefficients(app)
            value = round(get(app.Slider,'Value') * 64);
        end
        
        function set.NumDCTCoefficients(app,num_coefficients)
            set(app.Slider,'Value',num_coefficients/64)
            update(app);
        end
        
        function update(app)
            % Update the computation
            [recon_image,mask] = reconstructImage(app.OriginalImage, ...
                app.NumDCTCoefficients);
            
            diff_image = imabsdiff(app.OriginalImage, recon_image);
            
            % Update the app properties
            app.ReconstructedImage = recon_image;
            app.ErrorImage = diff_image;
            app.DCTCoefficientMask = mask;
            
            % Update the display
            imshow(app.OriginalImage,'Parent',app.OriginalImageAxes);
            title(app.OriginalImageAxes,'Original Image');
            
            imshow(recon_image,'Parent',app.ReconstructedImageAxes);
            title(app.ReconstructedImageAxes,'Reconstructed Image');
            
            imshow(diff_image,[],'Parent',app.ErrorImageAxes);
            title(app.ErrorImageAxes,'Error Image');
            
            displayCoefficientMask(mask,app.MaskAxes);

            drawnow;
        end
    end
    
end

function displayCoefficientMask(mask,ax)
imshow(mask,'Parent',ax)
for k = 0.5:1.0:8.5
    line('XData',[0.5 8.5], ...
        'YData',[k k], ...
        'Color',[0.6 0.6 0.6], ...
        'LineWidth',2, ...
        'Clipping','off', ...
        'Parent',ax);
    line('XData',[k k],...
        'YData',[0.5 8.5],...
        'Color',[0.6 0.6 0.6], ...
        'LineWidth',2,...
        'Clipping','off', ...
        'Parent',ax);
end
title(ax,'DCT Coefficient Mask')
end

function I = initialImage
pout = imread('pout.tif');
pout2 = pout(1:240,:);
I = im2double(adapthisteq(pout2));
end

function [I2,mask] = reconstructImage(I,n)
% Reconstruct the image from n of the DCT coefficients in each 8-by-8
% block. Select the n coefficients with the largest variance across the
% image. Second output argument is the 8-by-8 DCT coefficient mask.

% Compute 8-by-8 block DCTs.
f = @(block) dct2(block.data);
A = blockproc(I,[8 8],f);

% Compute DCT coefficient variances and decide
% which to keep.
B = im2col(A,[8 8],'distinct')';
vars = var(B);
[~,idx] = sort(vars,'descend');
keep = idx(1:n);

% Zero out the DCT coefficients we are not keeping.
B2 = zeros(size(B));
B2(:,keep) = B(:,keep);

% Reconstruct image using 8-by-8 block inverse
% DCTs.
C = col2im(B2',[8 8],size(I),'distinct');
finv = @(block) idct2(block.data);
I2 = blockproc(C,[8 8],finv);

mask = false(8,8);
mask(keep) = true;
end