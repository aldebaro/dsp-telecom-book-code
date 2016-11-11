a = 0.0; %a uses double precision
for i = 1:20
  a = a + 0.1; %20 times 0.1 should be equal to 2
end
a == 2 %checking if a is 2 returns false due to numerical errors

