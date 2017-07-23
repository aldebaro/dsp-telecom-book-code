function oct=view_oct(block)

oct = zeros(8,8);
for i=0:22
    oct(i+1,:) = block(1+i*8:8+i*8);
end
%message = oct