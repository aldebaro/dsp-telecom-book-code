function x = read_complex_binary(fileName, maxNumOfSamples)
%Read complex signal written as binary file.
%File is little-endian float values, real and imaginary
%interleaved: xreal[0],ximag[0],xreal[1],ximag[1],xreal[2],ximag[2]..
%Returns as column vector.
%maxNumOfSamples is the maximum number of complex samples.
%If maxNumOfSamples is not specified, all samples are read.
if (nargin < 2)
    maxNumOfSamples = Inf;
end
fp = fopen (fileName, 'rb');
if (fp < 0)
    error(['Could not open ' fileName]);
else
    t = fread (fp, [2, maxNumOfSamples], 'float');    
    x = t(1,:) + t(2,:)*1i;
    x=x(:); %make it a column vector
end
fclose (fp);