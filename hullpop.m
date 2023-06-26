tempv = reshape(tempfine,[],1);
rainv = reshape(rainfine,[],1);
PCv = reshape(PC(:,:,1),[],1);
PDv = reshape(PD(:,:,1),[],1);

rainv = rainv(~isnan(tempv));
PCv = PCv(~isnan(tempv));
PDv = PDv(~isnan(tempv));
tempv = tempv(~isnan(tempv));

tempv = tempv(~isnan(rainv));
PCv = PCv(~isnan(rainv));
PDv = PDv(~isnan(rainv));
rainv = rainv(~isnan(rainv));

tempv = tempv(~isnan(PCv));
rainv = rainv(~isnan(PCv));
PDv = PDv(~isnan(PCv));
PCv = PCv(~isnan(PCv));

tempv = tempv(~isnan(PDv));
rainv = rainv(~isnan(PDv));
PCv = PDv(~isnan(PDv));
PDv = PCv(~isnan(PDv));

%%
for i=1:31,
    tempaux = reshape(tempfine,[],1);
    rainaux = reshape(rainfine,[],1);
    PCaux = reshape(PC(:,:,i),[],1);
    PDaux = reshape(PD(:,:,i),[],1);

    tempaux = tempaux(~isnan(PCaux));
    rainaux = rainaux(~isnan(PCaux));
    PDaux = PDaux(~isnan(PCaux));
    PCaux = PCaux(~isnan(PCaux));
    
    rainaux = rainaux(~isnan(tempaux));
    PCaux = PCaux(~isnan(tempaux));
    PDaux = PDaux(~isnan(tempaux));
    tempaux = tempaux(~isnan(tempaux));
    
    PCaux = PCaux(~isnan(rainaux));
    PDaux = PDaux(~isnan(rainaux));
    tempaux = tempaux(~isnan(rainaux));
    rainaux = rainaux(~isnan(rainaux));
    
    PCaux = PCaux(~isnan(PDaux));
    tempaux = tempaux(~isnan(PDaux));
    rainaux = rainaux(~isnan(PDaux));
    PDaux = PDaux(~isnan(rainaux));
    
    avgtemp(i) = PCaux'*tempaux/sum(PCaux);
    avgrain(i) = PCaux'*rainaux/sum(PCaux);
end

%%
writematrix([PCaux PDaux rainaux tempaux],'hyde.csv');

%%
plot(avgtemp,avgrain)
%label('10000BC' '9000BC');

%%
[hull, hull1, rainp, tempp, a] = peeledhull(rainv,tempv,0.95);
figure
plot(rainv,tempv,'*')
hold on
plot(rainp(hull1),tempp(hull1))

%%
[hullw, hullw1, rainw, tempw, a] = peelwhull(rainv,tempv,PCv,0.95);
figure
plot(rainv,tempv,'*')
hold on
plot(rainw(hullw1),tempw(hullw1))

%%
[hullw0, hullw01, rainw0, tempw0, a] = peelwhull(rainv,tempv,PCv,0.95);
figure
plot(rainv,tempv,'*')
hold on
plot(rainw0(hullw01),tempw0(hullw01))

%%
figure
plot(rainw(hullw1),tempw(hullw1),'r')
hold on
plot(rainw0(hullw01),tempw0(hullw01),'b')
legend('2000 AD','10000 BC')
xlabel('Annual mean precipitation (millimetres per year)')
ylabel('Annual mean temperature (degree Celsius)')
%%
tic
k = convhull(tempv,rainv,PDv);
toc

%%
figure
trisurf(k,tempv,rainv,PDv)

%%
tic
[kp, tempp, rainp, PDp, a] = peel3dhull(tempv,rainv,PDv,0.95);
toc

%%
figure
trisurf(kp,tempp,rainp,PDp)