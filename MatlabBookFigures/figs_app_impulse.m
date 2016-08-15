%pmf for dice rolling
close all
x=1:6;
y=1/6*ones(1,6);
stem(x,y);
axis([0 7 0 0.2])
xlabel('r.v. value')
ylabel('probability')
writeEPS('app_diceexample');

%gaussian
x=-3:0.1:7;
y=octave_normpdf(x,2,1);
plot(x,y)
xlabel('r.v. value')
ylabel('probability density')
writeEPS('app_awgnexample');

%interval
data = octave_normrnd(2,1,10000,1);
p = capaplot(data,[2 3])
axis([0 4 0 0.5])
xlabel('r.v. value')
ylabel('probability density')
%title('')
writeEPS('app_awgnshaded');

%impulse
x=1:6;
y=1/6*ones(1,6);
ak_impulseplot(y,x,[]);
axis([0 7 0 0.2])
xlabel('r.v. value')
ylabel('probability density')
writeEPS('app_dicepdf');
