function [hull,hull1,x1,y1,a] = peelwhull(x,y,w,alpha)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

hull = convhull(x,y);
hull1 = hull;
cover = sum(w);
x1 = x;
y1 = y;
w1 = w;
a = 1;

while a > alpha,
    hull0 = hull1;
    x0 = x1;
    y0 = y1;
    w0 = w1;
    j=0;
    clear x1 y1 w1
    for i=1:length(x0),
        if sum(hull0==i) == 0,
            j=j+1;
            x1(j) = x0(i);
            y1(j) = y0(i);
            w1(j) = w0(i);
        end
    end
    hull1 = convhull(x1,y1);
    a = sum(w1)/cover;
end

end