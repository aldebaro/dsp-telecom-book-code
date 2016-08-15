N=1000; thresholds = linspace(-2,2,N); Pe = zeros(1,N);
for i=1:N %loop over the defined grid of thresholds
    Pe1=0.2*(-thresholds(i)); Pe2=1/3*(thresholds(i)+1);
    if Pe1<0 Pe1=0; end %a probability cannot be negative
    if Pe2<0 Pe2=0; end %a probability cannot be negative
    Pe(i) = 0.9*Pe1+0.1*Pe2;%prob. error for thresholds(i)
end
plot(thresholds, Pe); %visualize prob. for each threshold

