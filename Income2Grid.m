%Income2Grid
%This script combines two data sources (per capita income in a polygon, and
%gridded population data) to project total income and per capita income to
%grid cells
%
%Richard S.J Tol, 1 June 2020

%%
%download income data from https://globaldatalab.org/areadata/gnic/
importInc
%note that they pulled the data on rich countries, can be found in the
%accompanying .csv file

%%
%download shapefile from https://globaldatalab.org/shdi/shapefiles/
GDL = shaperead('C:\Users\rtol\Google Drive\JEP\GDL\GDL Shapefiles V4.shp');

%%
%download population count from https://sedac.ciesin.columbia.edu/data/set/gpw-v4-population-count-rev11
%importGPW

%%
%add field to structure
GDL(1).income = 0;

%add income to structure
for i=1:size(GDL),
    %GDL(i).income = Regions.VarName29(Regions.GDLCODE==GDL(i).GDLcode);
    GDL(i).income = RegionalIncome.Income(RegionalIncome.GDLCODE1==GDL(i).GDLcode);
end

%%
NLong = 4320;
NLat = 2160;
Long = -180;
for i = 2:NLong,
    Long(i) = Long(i-1) + 1/6;
end
Lat = -90;
for i = 2:NLat,
    Lat(i) = Lat(i-1) + 1/6;
end

%%
Res = 12;
population = rot90(PD(:,:,31)');
income = zeros(NLat,NLong);
count = zeros(NLat,NLong);
for i = 1:size(GDL),
    disp(i)
    [z, r]= vec2mtx(GDL(i).Y,GDL(i).X,Res,[-90 90],[-180 180]);
    y = z;
    for j=2:2160,
        for k=2:4320,
            if z(j,k)==0 & sum(z(1:j-1,k))>0 & sum(z(j+1:2160,k))>0 & sum(z(j,1:k-1))>0 & sum(z(j,k+1:4320))>0
                y(j,k) = 1;
            end
        end
    end
    if ~isempty(GDL(i).income)
        income  = income + GDL(i).income*(y-0.5*z).*population;
    end
    count = count + (y-0.5*z).*population;
end

income = income./population;

save('GDL.mat','income')

%%
mesh(Long,Lat,log(income))

%%
mesh(Long,Lat,log(income./PC))