function outImage=ak_dctdemo(imageFile, numCoeffToKeep, blockSize)
%function outImage=ak_dctdemo(imageFile, numCoeffToKeep, blockSize)
%Inputs:
%   imageFile => input file name, e.g., 'c:/myimage.jpg'
%   numCoeffToKeep => number of DCT coefficients to be used
%   blockSize => block size, e.g., use 8 for a block of 8x8 pixels
%Output: 
%   outImage => reconstructed image
%Example of usage:
% outImage=ak_dctdemo('lenna.tiff',3,8); imagesc(outImage)

[im,map]=imread(imageFile);
%im=uint8(magic(8))
[M N D]=size(im);
disp([num2str(M) 'x' num2str(N) ' pixels image with ' ...
    num2str(D) ' components']);

numRows = floor(M/blockSize);
numColumns = floor(N/blockSize);

outImage=zeros(size(im)); %pre-allocate space

%find the coefficients that should be discarded. Use a
%zig-zag scan
mask=ak_getZigzagMask(numCoeffToKeep, blockSize);
coeffIndicesToDiscard = find(mask==0);

blockNum=0; %number of processed blocks
disp('Processing...');
for d=1:D
    X = double(im(:,:,d)); %extract each compoment
    for i=0:numRows-1
        for j=0:numColumns-1
           rb = i*blockSize+1; %first row index (begin)
           re = rb+blockSize-1; %last index (end)
           cb = j*blockSize+1; %first index for column
           ce = cb+blockSize-1;
           block=X(rb:re,cb:ce); %extract block
           dctCoeff=octave_dct2(block); %calculate DCT
           dctCoeff(coeffIndicesToDiscard)=0; %discard
           %calculate IDCT
           outImage(rb:re,cb:ce,d)=octave_idct2(dctCoeff);
           blockNum=blockNum+1; %update block counter
        end
    end
end
disp([num2str(blockNum) ' blocks processed']);

%disabled below because it does not seem necessary
if 0 %convert image pixels to a range from 0 to 255
    minimum = min(outImage(:));
    maximum= max(outImage(:));
    outImage = 255 * (outImage-minimum)/(maximum-minimum);
end

outImage = uint8(outImage); %convert from double to uint8
errorImage = im-outImage;
PSNR=10*log10(255^2 / mean(errorImage(:).^2));
disp(['PSNR = ' num2str(PSNR) ' dB and ' ...
  'Max abs error = ' num2str(max(abs(errorImage(:))))]);
colormap(map); %use the proper color map
image(outImage)
axis off         %Remove axis ticks and numbers
axis image       %Set aspect ratio to obtain square pixels
