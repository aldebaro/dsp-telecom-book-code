function x_hat=ak_nonuniform_quantizer(x,codebook)
%  function x_hat=ak_nonuniform_quantizer(x,codebook)
%Finds the output for a non-uniform quantizer described by codebook.
%Inputs:  x are the input scalar numbers to be quantized.
%         codebook - set of quantizer output levels organized as a vector
%Output:  x_hat has the quantizer outputs
%Usage:
%x=[1,0,-1,-2,0.1,3], c=[-2,-1,0,1], x_hat=ak_nonuniform_quantizer(x,c)
if ~isvector(x)
   error('Input must be a scalar or a vector');
end
if ~isvector(codebook)
   error('Codebook must be a vector');
end
x=transpose(x(:)); %make sure x is a row vector
codebook=transpose(codebook(:)); %make sure constel is a row vector

S=length(x);
x_hat=zeros(1,S); %pre-allocate space for S outputs
for i=1:S %loop over all S input vectors in x
    this_error = x(i) - codebook;
    this_error = this_error .* this_error; %squared error
    [min_value, min_index] = min(this_error);
    x_hat(i) = codebook(min_index);
end