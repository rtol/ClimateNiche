function [k,x1,y1,z1,a] = peel3dhull(x,y,z,alpha)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

[hull area] = convhull(x,y,z);

hull1 = hull;
area1 = area;
x1 = x;
y1 = y;
z1 = z;
a = 1;

while a > alpha,
    hull0 = hull1;
    area0 = area1;
    x0 = x1;
    y0 = y1;
    z0 = z1;
    j=0;
    for i=1:length(x0),
        if sum(hull0(:,1)==i)==0 & sum(hull0(:,2)==i)==0 & sum(hull0(:,3)==i)==0,
            j=j+1;
            x1(j) = x0(i);
            y1(j) = y0(i);
            z1(j) = z0(i);
        end
    end
    x1 = x1(1:j);
    y1 = y1(1:j);
    z1 = z1(1:j);
    [hull1 area1] = convhull(x1,y1,z1);
    %a = length(x1)/length(x)
    a = area1/area
end

k= hull1;

end