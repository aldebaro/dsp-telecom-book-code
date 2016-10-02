%obs: I'm using Matlab version 7 R14. Maybe some commands don't exist for 6
clear all;
myimage = imread('image.jpg');  %read image from disk
%you can use other images
%myimage = imread('c:\some_image.jpg');  %read image from disk
disp('show image dimension:');
size(myimage)
bwimage=im2bw(myimage);  %convert it to black and white (binary) image
x=im2double(bwimage); %convert binary image to doubles, to write in file
save 'image.txt' x -ascii  %save file
imagesc(myimage); title('original image'); pause %show original image
imagesc(bwimage); title('black & white image');