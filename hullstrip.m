function [v1,w1,x1,y1,z1,h1,a1] = hullstrip(v,w,x,y,z,h)

j=0;
for i=1:length(x),
    if sum(h==i) == 0,
       j=j+1;
       v1(j) = v(i);
       w1(j) = w(i);
       x1(j) = x(i);
       y1(j) = y(i);
       z1(j) = z(i);
    end
end
v1 = v1';
w1 = w1';
x1 = x1';
y1 = y1';
z1 = z1';
[h1, a1] = convhull(v1,w1);