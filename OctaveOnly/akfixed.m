reset_fixed_operations;
fixed_point_count_operations = 1; %count number of fixed point operations, for later complexity analysis

is=0;
ds=1;
N=100;
Xmax=4;
x=linspace(-Xmax,Xmax,N);
xq=zeros(1,N);

clf; hold on
for i=1:N
	a = fixed(is, ds, x(i));
	xq(i)=a.x;
end
plot(x,xq);

display_fixed_operations