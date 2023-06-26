function [hull,hull1,x1,y1,a,area] = peeledhull(x,y,alpha)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

[hull,area] = convhull(x,y);
hull1 = hull;
area1 = area;
x1 = x;
y1 = y;
a = 1;

while a > alpha,
    hull0 = hull1;
    area0 = area1;
    x0 = x1;
    y0 = y1;
    j=0;
    clear x1 y1
    for i=1:length(x0),
        if sum(hull0==i) == 0,
            j=j+1;
            x1(j) = x0(i);
            y1(j) = y0(i);
        end
    end
    [hull1, area1] = convhull(x1,y1);
    a = length(x1)/length(x);
end

end