delta=0.5; %quantization step
b=3; %number of bits
x=[-5:.01:4]; %define input dynamic range
[x_hat, passos] = ak_quantizer(x,delta,b); %quantize
plot(x,x_hat), grid	%generate graph

