tic
[hull, hull1, ypc1, temp1, a, area] = peeledhull(log(ypc),temp,0.95);
toc

%%
tic
[bh,bh1,bypc,btemp,ba,barea] = bootstraphull(log(ypc),temp,0.95,1000);
toc

%%
[bvs bvi] = sort(bv);

lower = bvi(25);
upper = bvi(975);

lhull = bh1(:,lower);
lypc = bypc(:,lower);
ltemp = btemp(:,lower);
lhull = lhull(lhull>0);

uhull = bh1(:,upper);
uypc = bypc(:,upper);
utemp = btemp(:,upper);
uhull = uhull(uhull>0);

%%
auxtemp = temp1(hull1);
auxypc = ypc1(hull1);
meantemp = sum(auxtemp)/length(auxtemp);
meanypc = sum(auxypc)/length(auxypc);

ltemp = auxtemp.*(1.1*(temp>meantemp) + 0.9*(temp<meantemp));
utemp = auxtemp.*(1.1*(temp<meantemp) + 0.9*(temp>meantemp));
lypc = auxypc.*(1.1*(ypc>meanypc) + 0.9*(ypc<meanypc));
uypc = auxypc.*(1.1*(ypc<meanypc) + 0.9*(ypc>meanypc));


%%
plot(temp,log(ypc),'*')
%plot(temp(hull),log(ypc(hull)),'b')
hold on
plot(temp1(hull1),ypc1(hull1),'b')
%plot(ltemp(lhull),lypc(lhull),'b--')
%plot(utemp(uhull),uypc(uhull),'b--')
plot(ltemp,lypc,'b--')
plot(utemp,uypc,'b--')
xlabel('annual mean temperature (degree Celsius)')
ylabel('income (dollar per person per year, natural logarithm)')