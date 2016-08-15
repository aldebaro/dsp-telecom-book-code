%Generates a 4-PAM eye-diagram with a pulse as p[n]
N = 100; %Number of symbols 
a = [-3 -1 1 3]; % Symbol alphabet
ind = floor(4*rand(N,1)) + 1;  %Integers between 1 and 4
pam = a(ind); % Generate 4-PAM symbol sequence
L = 3; % Oversampling factor
p = ones(1,L); %use a square pulse as shaping pulse
pams = zeros(size(1:L*N)); %pre-allocate space
pams(1:L:L*N) = pam; %sequence {a1 0 0 a2 0 0 a3 ...}
xn = filter(p,1,pams); % Pulse shaping filtering
increment = 3*L; %Number of samples to be shown
firstSample=1; %First sample to be shown
hold on; %Make the plots superimpose each other
lastSample = length(xn) - increment; %Last sample
abscissa = 0:increment-1; %Create a fixed x-axis
for i=firstSample:increment:lastSample
    segment = xn(i:i+increment-1) %show values
    plot(abscissa,segment,'bx-'); %plot these values
    pause %wait the user to observe the diagram formation
end 

