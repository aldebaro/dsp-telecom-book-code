N=256; %desired number of samples of window W
W=rectwin(N); %Rectangular window
W=hamming(N); %Hamming window
W=hanning(N); %Hann window
W=kaiser(N,7.85); %Kaiser with beta=7.85
W=flattopwin(N); %Flat top window

