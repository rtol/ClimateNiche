function [bh,bh1,bx,by,ba,bv] = bootstraphull(x,y,alpha,n)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

%[hull,hull1,x1,y1,a] = peeledhull(x,y,alpha);

[bootstat bootsam] = bootstrp(n,[],y);

bh = zeros(length(x),n);
bh1 = bh;
bx = bh;
by = bh;
ba = zeros(1,n);
bv = zeros(1,n);

for i=1:n,
    [auxbh, auxbh1,auxbx,auxby,ba(i),bv(i)] = peeledhull(x(bootsam(:,i)),y(bootsam(:,i)),alpha);
    bh(1:length(auxbh),i) = auxbh;
    bh1(1:length(auxbh1),i) = auxbh1;
    bx(1:length(auxbx),i) = auxbx;
    by(1:length(auxby),i) = auxby;
end

end