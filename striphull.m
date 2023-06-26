clear all
%load('C:\Users\rtol\data\HYDE\temperature.mat')
%load('C:\Users\rtol\data\HYDE\rainfall.mat')
load('C:\Users\rtol\data\CRU\CRU.mat')
load('C:\Users\rtol\data\HYDE\popdens.mat')
load('C:\Users\rtol\data\HYDE\popcount.mat')
load('GDL')

%%
tempfine = zeros(2160,4320);
rainfine = zeros(2160,4320);
for i=1:360,
    for j=1:720,
        for k=1:6,
            for l=1:6,
                tempfine(6*(i-1)+k,6*(j-1)+l) = temp(i,j);
                rainfine(6*(i-1)+k,6*(j-1)+l) = prec(i,j);
            end
        end
    end
end

%%
hold on

for i=1:31,
incv = reshape(income,[],1);
    
tempv = reshape(tempfine,[],1);
rainv = reshape(rainfine,[],1);

PCv = reshape(rot90(PC(:,:,i)'),[],1);
PDv = reshape(rot90(PD(:,:,i)'),[],1);

rainv = rainv(~isnan(tempv));
PCv = PCv(~isnan(tempv));
PDv = PDv(~isnan(tempv));
incv = incv(~isnan(tempv));
tempv = tempv(~isnan(tempv));

tempv = tempv(~isnan(rainv));
PCv = PCv(~isnan(rainv));
PDv = PDv(~isnan(rainv));
incv = incv(~isnan(rainv));
rainv = rainv(~isnan(rainv));

climatehull = convhull(rainv,tempv);
climaterain = rainv;
climatetemp = tempv;

tempv = tempv(~isnan(PCv));
rainv = rainv(~isnan(PCv));
incv = incv(~isnan(PCv));
PDv = PDv(~isnan(PCv));
PCv = PCv(~isnan(PCv));

tempv = tempv(~isnan(PDv));
rainv = rainv(~isnan(PDv));
incv = incv(~isnan(PDv));
PCv = PCv(~isnan(PDv));
PDv = PDv(~isnan(PDv));

tempv = tempv(~isnan(incv));
rainv = rainv(~isnan(incv));
PCv = PCv(~isnan(incv));
PDv = PDv(~isnan(incv));
incv = incv(~isnan(incv));

tempv = tempv(PDv>0);
rainv = rainv(PDv>0);
incv = incv(PDv>0);
PCv = PCv(PDv>0);
PDv = PDv(PDv>0);
areav = PCv./PDv;

[hull areahist(i)] = convhull(rainv,tempv);

plot(rainv(hull),tempv(hull))
end
xlabel('Precipitation (centimetres per year)')
ylabel('Temperature (degree Celsius)')
hold off

%%
figure
hull = convhull(rainv,tempv);
plot(rainv(hull),tempv(hull))
hold on
for i=1:99
    prct = prctile(PDv,i);
    auxr = rainv(PDv>prct);
    auxt = tempv(PDv>prct);
    [hull,auxa(i)] = convhull(auxr,auxt);
    plot(auxr(hull),auxt(hull))
end
xlabel('Precipitation (centimetres per year)')
ylabel('Temperature (degree Celsius)')
hold off

plot(auxa)
xlabel('percentile population density')
ylabel('area inside convex hull')
%%
figure
hull = convhull(rainv,tempv);
plot(rainv(hull),tempv(hull))
hold on
edge = [1 5 10 25 50 75 90 95 99]; 
for i=1:99 %length(edge)
    %prct = prctile(incv,edge(i));
    prct = prctile(incv,i);
    auxr = rainv(incv>prct);
    auxt = tempv(incv>prct);
    [hull,auxb(i)] = convhull(auxr,auxt);
    plot(auxr(hull),auxt(hull))
end
xlabel('Precipitation (centimetres per year)')
ylabel('Temperature (degree Celsius)')
%legend('0', '1', '5', '10', '25', '50', '75', '90', '95', '99')
hold off

%%
plot(auxb)
xlabel('percentile per capita income')
ylabel('area inside convex hull')

%%
aux=unique([tempv rainv],'rows');
vtemp = aux(:,1);
vrain = aux(:,2);

N = length(vtemp);
vPC = zeros(N,1);
vArea = zeros(N,1);

for i=1:N
    vPC(i) = sum(PCv(tempv==vtemp(i) & rainv==vrain(i)));
    vArea(i) = sum(areav(tempv==vtemp(i) & rainv==vrain(i)));
    vPCmargt(i) = sum(PCv(tempv==vtemp(i)));
    vAreamargt(i) = sum(areav(tempv==vtemp(i)));
    vPCmargr(i) = sum(PCv(rainv==vrain(i)));
    vAreamargr(i) = sum(areav(rainv==vrain(i)));
end

%%
tempv = vtemp;
rainv = vrain;
PCv = vPC;
areav = vArea;
PDv = PCv./areav;
PCmt = vPCmargt;
areamt = vAreamargt;
PDmt = PCmt./areamt;
PCmr = vPCmargr;
areamr = vAreamargr;
PDmr = PCmr./areamr;

clear aux ans tempfine temp prec rainfine PD PC v*

save humanniche

%%
load humanniche

[hull,harea(1)] = convhull(rainv,tempv);

S(1).hull = hull;
S(1).rain = rainv;
S(1).temp = tempv;
S(1).PD = PDv;
S(1).PC = PCv;
S(1).area = areav;

%stripped = length(hull);
stripped = sum(S(1).PC(S(1).hull));
pop = sum(S(1).PC);

i=1;
%while stripped/length(rainv) < 0.05,
while stripped/pop < 0.05,
    i=i+1
    [S(i).rain,S(i).temp,S(i).PD,S(i).PC,S(i).area,S(i).hull,harea(i)] = hullstrip(S(i-1).rain,S(i-1).temp,S(i-1).PD,S(i-1).PC,S(i-1).area,S(i-1).hull);
    %stripped = stripped + length(S(i).hull);
    stripped = stripped + sum(S(i).PC(S(i).hull));
end

%%
figure
plot(rainv,tempv,'*')
xlabel('Precipitation (centimetres per year)')
ylabel('Temperature (degree Celsius)')

%%
figure
plot(rainv,tempv,'*')
hold on
plot(S(1).rain(S(1).hull),S(1).temp(S(1).hull))
xlabel('Precipitation (centimetres per year)')
ylabel('Temperature (degree Celsius)')
hold off

%%
figure
plot(rainv,tempv,'*')
hold on
for i=1:length(S),
    plot(S(i).rain(S(i).hull),S(i).temp(S(i).hull))
end
xlabel('Precipitation (centimetres per year)')
ylabel('Temperature (degree Celsius)')
hold off

%%
figure
plot(climaterain(climatehull),climatetemp(climatehull),'red')
hold on
plot(S(1).rain(S(1).hull),S(1).temp(S(1).hull),'green')
plot(S(length(S)).rain(S(length(S)).hull),S(length(S)).temp(S(length(S)).hull),'blue')
xlabel('Precipitation (centimetres per year)')
ylabel('Temperature (degree Celsius)')
hold off

%%
Lpath = length(S);

avetemp = sum(S(Lpath).temp(S(Lpath).hull))/length(S(Lpath).temp(S(Lpath).hull));
averain = sum(S(Lpath).rain(S(Lpath).hull))/length(S(Lpath).rain(S(Lpath).hull));
mintemp = min(tempv);
maxtemp = max(tempv);
minrain = min(rainv);
maxrain = max(rainv);

L1 = zeros(2,2,8);

L1(:,:,1) = [avetemp maxtemp; averain averain];
L1(:,:,2) = [avetemp maxtemp; averain maxrain];
L1(:,:,3) = [avetemp avetemp; averain maxrain];
L1(:,:,4) = [avetemp mintemp; averain maxrain];
L1(:,:,5) = [avetemp mintemp; averain averain];
L1(:,:,6) = [avetemp mintemp; averain minrain];
L1(:,:,7) = [avetemp avetemp; averain minrain];
L1(:,:,8) = [avetemp maxtemp; averain minrain];

for j=1:8,
    for i=Lpath:-1:1,
        L2 = [S(i).temp(S(i).hull)'; S(i).rain(S(i).hull)'];
        aux = InterX(L1(:,:,j),L2);
        temppath(j,i) = aux(1);
        rainpath(j,i) = aux(2);
    end
end
%%
figure
hold on
for i=1:length(S),
    plot(S(i).rain(S(i).hull),S(i).temp(S(i).hull))
end
for i=1:8,
    plot(rainpath(i,:),temppath(i,:),'black','LineWidth',2)
end
xlabel('Precipitation (centimetres per year)')
ylabel('Temperature (degree Celsius)')
hold off
%%
for i=1:8,
    temppath(i,:) = sort(temppath(i,:)+273,'descend');
    rainpath(i,:) = sort(rainpath(i,:),'descend');
    [Ht(i) Htsd(i) Qt(i) Qtsd(i)] = tailindex(temppath(i,:)');
    [Hr(i) Hrsd(i) Qr(i) Qrsd(i)] = tailindex(rainpath(i,:)');
end

store1 = real([Ht; Htsd; Qt; Qtsd; Hr; Hrsd; Qr; Qrsd]);

%%
rad = [pi/2 pi/4 0 7*pi/4 3*pi/2 5*pi/4 pi 3*pi/4];
polarscatter(rad,Ht,'red','filled')
hold on
for i=1:length(Ht)
    polarplot([rad(i) rad(i)], [Ht(i)-2*Htsd(i) Ht(i)+2*Htsd(i)],'red')
end
hold off

%%
polarscatter(rad,Hr,'blue','filled')
hold on
for i=1:length(Ht)
    polarplot([rad(i) rad(i)], [Hr(i)-2*Hrsd(i) Hr(i)+2*Hrsd(i)],'blue')
end

%%
harea = harea';
harea = sort(harea,'descend');

[H(1) Hsd(1) Q(1) Qsd(1)] = tailindex(harea);

H = 2*H;
Hsd = 2*Hsd;
Q = 2*Q;
Qsd = 2*Qsd;

%%
for i=1:Lpath,
    K = length(S(i).hull);
    perimeter(i) = euclid([S(i).temp(S(i).hull(1)) S(i).rain(S(i).hull(1))],[S(i).temp(S(i).hull(K)) S(i).rain(S(i).hull(K))]);
    popcount(i) = S(i).PC(S(i).hull(1));
    harea(i) = S(i).area(S(i).hull(1));
    for k=1:K-1,
        perimeter(i) = perimeter(i) + euclid([S(i).temp(S(i).hull(k)) S(i).rain(S(i).hull(k))],[S(i).temp(S(i).hull(k+1)) S(i).rain(S(i).hull(k+1))]);
        popcount(i) = popcount(i) + S(i).PC(S(i).hull(k));
        harea(i) = harea(i) + S(i).area(S(i).hull(k));
    end
end
            
perimeter = perimeter';
popdens = popcount./harea;
popcount = popcount'/K;
popdens = popdens';
perimeter = sort(perimeter,'descend');

[H(2) Hsd(2) Q(2) Qsd(2)] = tailindex(perimeter);

store2 = [[H(1); Hsd(1); Q(1); Qsd(1)] [H(2); Hsd(2); Q(2); Qsd(2)]];

%%
tempsort = sort(unique(tempv),'ascend');
[H(3) Hsd(3) Q(3) Qsd(3)] = tailindex(tempsort(end-length(S):end));

rainsort = sort(unique(rainv),'ascend');
[H(4) Hsd(4) Q(4) Qsd(4)] = tailindex(rainsort(end-length(S):end));

%%
figure
plot(rainv,tempv+3,'*')
hold on
plot(S(1).rain(S(1).hull),S(1).temp(S(1).hull),'red','LineWidth',2)
plot(S(length(S)).rain(S(length(S)).hull),S(length(S)).temp(S(length(S)).hull),'green','LineWidth',2)
xlabel('Precipitation (centimetres per year)')
ylabel('Temperature (degree Celsius)')
hold off

%%
for i=1:5,
    for j=1:5,
        in = inpolygon(max(0,rainv*(1.3-j/10)),tempv+i-1,S(1).rain(S(1).hull),S(1).temp(S(1).hull));
        popin(i,j) = sum(PCv(in))/pop;
    end
end
%%
tempgrid = mintemp;
raingrid = minrain;
for i=2:101,
    tempgrid(i) = tempgrid(i-1) + (maxtemp-mintemp)/100;
    raingrid(i) = raingrid(i-1) + (maxrain-minrain)/100;
end

for i=1:100,
    for j=1:100,
        histpop(i,j) = sum(PCv(tempv>tempgrid(i) & tempv<=tempgrid(i+1) & rainv>raingrid(j) & rainv<=raingrid(j+1)));
    end
end