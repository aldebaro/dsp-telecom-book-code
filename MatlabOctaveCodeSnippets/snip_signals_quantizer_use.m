delta=0.5; %quantization step
b=3; %number of bits, to be used here as range -2^(b-1) to 2^(b-1)-1
x=[-5:.01:4]; %define input dynamic range
[xq,x_integers] = ak_quantizer(x,delta,b); %quantize
plot(x,xq), grid	%generate graph

