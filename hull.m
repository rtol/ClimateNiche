%initialize
hull = convhull(ypc,temp);
hull0 = hull;
hull1 = hull;
temp0 = temp;
ypc0 = ypc;
alpha = 1;

while alpha > 0.95,
    j=0;
    for i=1:length(temp0),
        if sum(hull0==i) == 0,
            j=j+1;
            temp1(j) = temp0(i);
            ypc1(j) = ypc0(i);
        end
    end
    hull1 = convhull(ypc1,temp1);
    alpha = length(temp1)/length(temp);
    hull0 = hull1;
    temp0 = temp1;
    ypc0 = ypc1;
end

plot(temp,ypc,'*')
hold on
plot(temp(hull),ypc(hull))
plot(temp1(hull1),ypc1(hull1))