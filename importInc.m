%% Import data from text file
% Script for importing data from the following text file:
%
%    filename: C:\Users\rtol\Google Drive\JEP\GDL\GDL-Gross-National-Income-per-Capita-(in-1000-US$-2011-PPP)-data.csv
%
% Auto-generated by MATLAB on 01-Jun-2020 08:41:23

%% Setup the Import Options and import the data
opts = delimitedTextImportOptions("NumVariables", 33);

% Specify range and delimiter
opts.DataLines = [1, Inf];
opts.Delimiter = ",";

% Specify column names and types
opts.VariableNames = ["Country", "ISO_Code", "Level", "GDLCODE", "Region", "VarName6", "VarName7", "VarName8", "VarName9", "VarName10", "VarName11", "VarName12", "VarName13", "VarName14", "VarName15", "VarName16", "VarName17", "VarName18", "VarName19", "VarName20", "VarName21", "VarName22", "VarName23", "VarName24", "VarName25", "VarName26", "VarName27", "VarName28", "VarName29", "VarName30", "VarName31", "VarName32", "VarName33"];
opts.VariableTypes = ["categorical", "categorical", "categorical", "string", "string", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double"];

% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";

% Specify variable properties
opts = setvaropts(opts, ["GDLCODE", "Region"], "WhitespaceRule", "preserve");
opts = setvaropts(opts, ["Country", "ISO_Code", "Level", "GDLCODE", "Region"], "EmptyFieldRule", "auto");

% Import the data
Regions = readtable("C:\Users\rtol\Google Drive\JEP\GDL\GDL-Gross-National-Income-per-Capita-(in-1000-US$-2011-PPP)-data.csv", opts);


%% Clear temporary variables
clear opts