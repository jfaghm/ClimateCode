function [ output_args ] = compareRegression()
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

load /project/expeditions/lem/ClimateCode/Matt/matFiles/asoHurricaneStats.mat;

sstIndex = buildIndex4(1, 3, 10);

predictions  = singleRegress(sstIndex, aso_tcs);
[~,predictions2] = multipleRegress(sstIndex, aso_tcs);

output_args = predictions - predictions2;


end

