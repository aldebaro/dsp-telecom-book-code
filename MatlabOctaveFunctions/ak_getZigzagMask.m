function mask=ak_getZigzagMask(numCoeffToKeep, blockSize)
%numCoeffToKeep => number of coefficients to keep
%blockSize => the block is blockSize x blockSize
%e.g., ak_getZigzagMask(1, 8)
%returns a 8x8 matrix with all elements equal to zero but
%the one corresponding to DC at (1,1)

%Implement a zig-zag ordering such as in Z
%Z=1 3  6  10    => indices are  1,1 1,2 1,3 1,4       
%2 5  9  13                      2,1 2,2 2,3 2,4
%4 8  12 15                      3,1 3,2 3,3 3,4
%7 11 14 16                      4,1 4,2 4,3 4,4
if numCoeffToKeep<1
    warning('Num. of coefficients smaller than 1')
    mask=zeros(blockSize,blockSize);
    return
end
if numCoeffToKeep>blockSize*blockSize
    warning('Num. of coefficients larger than block size')
    mask=ones(blockSize,blockSize);
    return
end

mask= zeros(blockSize,blockSize); %pre-allocate space
num=0; %current number of coefficients
%1st process the left-upper triangle and the diagonal
for i=1:blockSize
    for j=1:i
        mask(i-j+1,j)=1; %mark it as used
        num=num+1; %update number of coefficients
        if num>=numCoeffToKeep
            return
        end
    end
end
%2nd process the right-lower triangle
for i=1:blockSize-1 %number of diagonals in lower matrix
    for j=1:blockSize-i;
        mask(blockSize-j+1,i+j)=1; %mark it as used
        num=num+1; %update number of coefficients
        if num>=numCoeffToKeep
            return
        end
    end
end
