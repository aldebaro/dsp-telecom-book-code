function bestCodewordIndex = ak_vectorQuantizer(vector, codebook)
% function bestCodewordIndex = ak_vectorQuantizer(vector, codebook)
%Encode input vector using N x K codebook matrix using the Euclidean
%distance (squared error). It outputs the best codeword index.
[numOfCodewords,K]=size(codebook);
minimumDistance = Inf; %initialize with large number
bestCodewordIndex = -1; %initialize with invalid number
vector = transpose(vector(:)); %make sure it is a row vector
for j=1:numOfCodewords %search all codewords in codebook
    error=vector-codebook(j,:); % error
    squaredError=sum(error.*error); %squared Euclidean distance
    if squaredError < minimumDistance %update
        bestCodewordIndex = j;
        minimumDistance = squaredError; %update the best
    end
end
