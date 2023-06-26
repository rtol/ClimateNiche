load humanniche

clear area* climate* i j k l PCm* PDm*
%%
[PD index]= sort(PDv,'descend');
PC = PCv(index);
rain = rainv(index);
temp = tempv(index);

clear PCv PDv rainv tempv index

%%
auxy = PD(round(N*9/10):end);
y = auxy/(min(auxy));
auxt = temp(round(N*9/10):end);
auxr = rain(round(N*9/10):end);
%x = [ones(length(y),1) auxt/max(auxt) auxr/max(auxr)];
x = [ones(length(y),1) auxt auxr];
clear aux*
%x = [ones(length(y),1)];

%%
[Hill Hillsd DJV1 DJV2 AM AMsd T1 T1sd T2 T3 D Dsd] = TailHill(y,length(y)-1);

clear DJ* AM* T1* T2 T3 D*

%%
beta0 = [log(Hill); 0; 0];

ALL = applik(y,x,beta0);

%%
[beta,fval,exitflag,output,grad,hessian] = fminunc(@(beta)applik(y,x,beta),beta0);
%[beta,fval,exitflag,output,grad,hessian] = fminunc(@(beta)applik(y,x,beta),log(Hill));